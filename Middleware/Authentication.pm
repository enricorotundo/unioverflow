package Middleware::Authentication;
use strict;
use warnings;
use CGI::Carp;

use Lib::Sanitize;
use Model::User;
use Middleware::Session;

# Effettua l'autenticazione (che è diversa dall'autorizzazione!)
#
# Richiede che sia stata aperta una sessione in $req->attr("session").
# Se l'utente si era già loggato, carica in $req->attr("user") il model dell'utente.
# Per fare il login basta chiamare Middleware::Authentication::login($req)
# Per fare il logout basta chiamare Middleware::Authentication::logout($req)
# Per sapere se l'utente è loggato basta chiamare Middleware::Authentication::isLogged($req)

sub handler {
	my ($req, $res) = @_;

	my $session = $req->attr("session");
	my $email = Lib::Sanitize::email($session->param("email"));
	
	if ($email) {
		my $user = Model::User::getUserByEmail($email);
		
		if ($user) {
			$req->attr("user", $user);
		}
	}
}

sub isLogged {
	if (@_ < 1) {
		die "Invalid number of parameters (".@_.")";
	}
	my ($req) = @_;

	if ($req->attr("user")) {
		return 1;
	} else {
		return "";
	}
}

sub login {
	my ($req) = @_;

	my $session = $req->attr("session");
	my $email = Lib::Sanitize::email($req->param("email"));
	my $password = Lib::Sanitize::password($req->param("password"));

	my $user = Model::User::getUserByEmail($email);
	if ($user and $user->checkPassword($password)) {
		$session->param("email", $email);
		$req->attr("user", $user);
	}
}

sub logout {
	my ($req) = @_;
	
	$req->attr("user", undef);
	Middleware::Session::destroySession($req);
}

1;