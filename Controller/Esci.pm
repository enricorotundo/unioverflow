package Controller::Esci;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	if (Middleware::Authentication::isLogged($req)) {
		$res->redirect("index.cgi");
		return;
	}
	
	# Response
	$res->write(Lib::Renderer::render('esci.html'));
}

1;