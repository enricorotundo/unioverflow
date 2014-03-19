package Controller::Esci;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Middleware::Authentication;

# Questo controller è completo
sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	Middleware::Authentication::logout($req);

	my $success;
	if (Middleware::Authentication::isLogged($req)) {
		$success = ""; # False in Perl
	} else {
		$success = 1; # True in Perl
	}

	my $data = {
		"success" => $success
	};
	
	# Response
	$res->write(Lib::Renderer::render('esci.html', $data));
}

1;