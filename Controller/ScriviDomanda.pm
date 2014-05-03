package Controller::ScriviDomanda;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Model::Question;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	my $data;
	my $title = $req->param("titolo") or "";
	my $content = $req->param("testo") or "";
	my $author = $req->param("autore") or "";

	# controllo se arrivo in scrivi-domanda inviando dei dati con POST
	if ($req->attr("method") eq 'POST') {
		my $fields_check = fieldsCheck($title, $content);

		if($fields_check->{"check"} ) {

			# inserisco nel db la domanda
			my $success;

			if (Model::Question::insertQuestion($title, $content, $author)) {
				$success = 1; 
			} else {
				$success = ""; 
			}

			
			$data = {
				"success" => $success
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
				"error" => 1,
				"msg" => $msg
			};
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

	# TODO trovare come verificare che il testo inserito non sia un'arma distruttiva 
	# if ($title ~= cattivoCodice) {
	# 		$title_check = 1;
	# } else {
	# 	$title_check = "";
	# }

	# if ($content =~ superCattivoCodice) {
	# 	$content_check = 1;
	# } else {
	# 	$content_check = "";
	# }

	$title_check = "";
	$content_check = "";
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