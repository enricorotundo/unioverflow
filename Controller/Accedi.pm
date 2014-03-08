package Controller::Accedi;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	# Execution
	my $data = {
		"username" => "Pippo"
	};

	# Response
	$res->write(Lib::Renderer::render('accedi.html', $data));
}

1;