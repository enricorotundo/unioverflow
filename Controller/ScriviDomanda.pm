package Controller::ScriviDomanda;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Lib::Utils;
use Middleware::Session;
use Middleware::Authentication;
use Model::Question;
use Lib::Sanitize; # Per filtrare gli input
use Lib::Utils;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	my $data = { };
	my $session = Middleware::Session::getSession($req);
	my $author = "";
	if ($session) {
		$author = $session->param("email") or "";
	}

	# controllo se arrivo in scrivi-domanda inviando dei dati con POST
	if ($req->attr("method") eq 'POST' and Middleware::Authentication::isLogged($req)) {
		my $fields_check = fieldsCheck(
			$req->param("titolo"),
			$req->param("testo")
		);

		if($fields_check->{"check"} ) {
			my $title = Lib::Sanitize::title($req->param("titolo"));
			my $content = Lib::Sanitize::content($req->param("testo"));
			
			# inserisco nel db la domanda
			my $success;

			my $newId = Model::Question::insertQuestion($title, $content, $author);
			if( $newId != 0 ) {
			#if (Model::Question::insertQuestion($title, $content, $author)) {
				$success = 1; 
			} else {
				$success = ""; 
			}

			$data = {
				"logged" => Middleware::Authentication::isLogged($req),
				"success" => $success,
				"newId" => $newId # ritorno l'id in modo da poter reindirizzare l'utente alla domanda inserita
			};			

		} else {
			# creo il msg di errore
			my $msg = "I seguenti campi contengono errori: ";
			if (not $fields_check->{"title_check"}) {
				$msg = $msg . "Titolo "
			}
			if (not $fields_check->{"content_check"}) {
				$msg = $msg . "Testo della domanda "
			}

			# Execution
			$data = {
				"logged" => Middleware::Authentication::isLogged($req),
				"error" => 1,
				"msg" => $msg
			};
		}
	}
	else {
		$data = { 
			"logged" => Middleware::Authentication::isLogged($req),
			"session" => {
				"email" => $author
			}
		}
	}

	# Response
	$res->write(Lib::Renderer::render('scrivi-domanda.html', $data));
}

# controllo la consistenza e la sicurezza dei dati inseriti
sub fieldsCheck {
	my ($title, $content) = @_;
	my $title_check;
	my $content_check;

	if (Lib::Utils::not_empty($title) and $title eq Lib::Sanitize::title($title) and length $title <= 300) {
		$title_check = 1;
	} else {
		$title_check = "";
	}

	if (Lib::Utils::not_empty($content) and $content eq Lib::Sanitize::title($content)) {
		$content_check = 1;
	} else {
		$content_check = "";
	}

	my $check;
	if($title_check and $content_check) {
		$check = 1;
	} else {
		$check = "";
	}

	return my $res = {
		"check" => $check,
		"content_check" => $content_check,
		"title_check" => $title_check,
	}
}

1;