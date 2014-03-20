package Controller::Accedi;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Middleware::Authentication;

# Questo controller è completo
sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	my $data = {
		"logged" => Middleware::Authentication::isLogged($req)
	};
	
	# Response
	$res->write(Lib::Renderer::render('accedi.html', $data));
}

1;