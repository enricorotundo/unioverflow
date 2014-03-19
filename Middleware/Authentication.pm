package Middleware::Authentication;
use strict;
use warnings;
use CGI::Carp;

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

	my $username = $session->param("username");
	my $user = Model::User::getUserByUsername($username);

	if ($user) {
		$req->attr("user", $user);
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

	my $username = $req->param("username");
	my $password = $req->param("password");

	my $user = Model::User::getUserByUsername($username);
	if ($user->checkPassword($password)) {
		$req->attr("user", $user);
	}
}

sub logout {
	my ($req) = @_;
	
	$req->attr("user", undef);
	Middleware::Session::destroySession($req);
}

1;