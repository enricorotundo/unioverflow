package Controller::Registrati;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	# TODO ...
	
	# Execution
	my $data = {
		"email" => "Pippo"
	};

	# Response
	$res->write(Lib::Renderer::render('registrati.html', $data));
}

1;