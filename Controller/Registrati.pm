package Controller::Registrati;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Model::User;
use Lib::Sanitize; # Per filtrare gli input
use Lib::Utils;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	my $data;

	# controllo se arrivo in registarti inviando dei dati con POST
	if ($req->attr("method") eq 'POST') {
		my $fields_check = fieldsCheck(
			$req->param("email"),
			$req->param("password"),
			$req->param("passwordconfirm")
		);

		if ($fields_check->{"check"}) {

			my $email = Lib::Sanitize::email($req->param("email"));
			my $password = Lib::Sanitize::password($req->param("password"));

			# controllo che l'utente non sia già presente nel db
			my $user = Model::User::getUserByEmail($email);
			if ($user) {

				# errore utente gia presente nel db
				# Execution
				$data = {
					"error" => 1,
					"msg" => "<p>L'email inserita è già stata utilizzata</p>"
				};

			} else {

				# inserisco nel db il nuovo utente
				$user = Model::User->new(
					"email" => $email,
					"password" => $password,
				);
				$user->save();

				# Execution
				$data = {
					"success" => 1
				};			
			}

		} else {
			# creo il msg di errore
			my $msg = "<p>Sono stati riscontrati i seguenti errori:</p><ul>";
			if (not $fields_check->{"email_check"}) {
				$msg = $msg . "<li>L'email deve finire con '\@studenti.unipd.it'</li>";
			}
			if (not $fields_check->{"password_check"}) {
				$msg = $msg . "<li>La password deve essere almeno di 8 caratteri e non può contenere caratteri speciali</li>";
			}
			if (not $fields_check->{"password_confirm_check"}) {
				$msg = $msg . "<li>La password di conferma non corrisponde!</li>";
			}
			$msg = $msg . "</ul>";

			# Execution
			$data = {
				"error" => 1,
				"msg" => $msg
			};
		}
	}
	
	# Response
	$res->write(Lib::Renderer::render('registrati.html', $data));
}

# controllo la consistenza dei dati inseriti
sub fieldsCheck {
	my ($email, $password, $password_confirm) = @_;
	my $email_check;
	my $password_check;
	my $password_confirm_check;

	if (Lib::Utils::not_empty($email) and $email eq Lib::Sanitize::email($email)) {
		$email_check = 1;
	} else {
		$email_check = "";
	}

	if (Lib::Utils::not_empty($password) and $password eq Lib::Sanitize::password($password)) {
		$password_check = 1;
	} else {
		$password_check = "";
	}

	if ($password eq $password_confirm) {
		$password_confirm_check = 1;
	} else {
		$password_confirm_check = "";
	}

	my $check;
		if($email_check and $password_confirm_check and $password_check) {
			$check = 1;
		} else {
			$check = "";
	}

	return my $res = {
		"check" => $check,
		"email_check" => $email_check,
		"password_check" => $password_check,
		"password_confirm_check" => $password_confirm_check
	}
}

1;