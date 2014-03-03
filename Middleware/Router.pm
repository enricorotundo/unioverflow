package Middleware::Router;
use strict;
use warnings;
use CGI::Carp;

use Lib::Response;
use Controller::ErrorNotFound;

my $routes = [
	[ "/index",		"Controller::Index" ],
	[ "/login",		"Controller::Login" ],
	[ "/logout",	"Controller::Logout" ],
	[ "/profile",	"Controller::Profile" ],
];

sub isMatch {
	my ($route, $path) = @_;

	if ($route cmp $path) {
		# diverse
		return ""; # false
	} else {
		# uguali
		return 1; # true
	}
}

sub handler {
	my ($req, $res) = @_;

	# Trova il controller che gestisce la richiesta
	for my $pair (@$routes) {
		my ($route, $controller_module) = @$pair;
		
		if (isMatch($route, $req->path())) {
			# Carica il controller ed eseguilo
			eval "require $controller_module" or die $@;
			eval "&".$controller_module."::handler(\$req, \$res)" or die $@;
			return;
		}													
	}

	# Richiesta non gestita
	Controller::ErrorNotFound::handler($req, $res);
}

1;