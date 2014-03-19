package Controller::Index;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Middleware::Authentication;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	# Execution
	my $data = {
		"logged" => Middleware::Authentication::isLogged($req)
	};

	# Response
	$res->write(Lib::Renderer::render('index.html', $data));
}

1;