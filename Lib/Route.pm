package Lib::Route;
use strict;
use warnings;
use CGI::Carp;
use Lib::Response;
use Controller::ErrorNotFound;

#################################################################
#################################################################
###                                                           ###
###  QUESTO FILE NON VA USATO, FORSE LO CANCELLERÒ IN FUTURO  ###
###                                                           ###
#################################################################
#################################################################

my $routes = [
	[ "/index",		"Controller::Index" ],
	[ "/login",		"Controller::Login" ],
	[ "/logout",	"Controller::Logout" ],
	[ "/profile",	"Controller::Profile" ],
];

sub isMatch {
	my ($route, $request) = @_;

	if ($route cmp $request->get_path()) {
		# diverse
		return ""; # false
	} else {
		# uguali
		return 1; # true
	}
}

sub handler {
	my ($request) = @_;

	# Trova il controller che gestisce la richiesta
	for my $pair (@$routes) {
		my ($route, $controller_module) = @$pair;
		
		if (isMatch($route, $request)) {
			# Carica il controller ed eseguilo
			eval "require $controller_module" or die $@;
			my $response = eval "&".$controller_module."::handler(\$request)" or die $@;

			return $response;
		}													
	}

	# Richiesta non gestita
	my $response = Controller::ErrorNotFound::handler($request);
	return $response;
}

1;