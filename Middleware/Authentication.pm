package Middleware::Authentication;
use strict;
use warnings;
use CGI::Carp;

use Model::User;
use Middleware::Session;

# Autenticazione (non autorizzazione)

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