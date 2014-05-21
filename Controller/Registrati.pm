package Controller::Registrati;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Model::User;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	my $data;
	my $email = $req->param("email") or "";
	my $password = $req->param("password") or "";
	my $password_confirm = $req->param("passwordconfirm") or "";

	# controllo se arrivo in registarti inviando dei dati con POST
	if ($req->attr("method") eq 'POST') {
		my $fields_check = fieldsCheck($email, $password, $password_confirm);

		if($fields_check->{"check"} ) {

			# controllo che l'utente non sia già presente nel db
			my $user = Model::User::getUserByEmail($email);
			if ($user) {

				# errore utente gia presente nel db
				# Execution
				$data = {
					"error" => 1,
					"msg" => "L'email utilizzata è già utilizzata"
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
			my $msg = "I seguenti campi contengono errori: <br>";
			if (not $fields_check->{"email_check"}) {
				$msg = $msg . "L'email deve finire con 'studenti.unipd.it' <br>"
			}
			if (not $fields_check->{"password_check"}) {
				$msg = $msg . "La password deve essere almeno di 8 caratteri e non può contenere caratteri speciali<br>"
			}
			if (not $fields_check->{"password_confirm_check"}) {
				$msg = $msg . "La password di Conferma non corrisponde!"
			}

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

	# Mettere ^ all'inizio e $ alla fine della regexp per garantire
	# che tutto rispetti la regexp, e non solo una sottostringa
	if ($email =~ m/^[a-z.0-9]{1,64}\@studenti.unipd.it$/) {
			$email_check = 1;
	} else {
		$email_check = "";
	}

	# Mettere ^ all'inizio e $ alla fine della regexp per garantire
	# che tutto rispetti la regexp, e non solo una sottostringa
	if ($password =~ m/^[a-zA-Z0-9]{8,24}$/) {
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