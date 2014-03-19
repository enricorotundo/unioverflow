package Controller::ScriviDomanda;
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
	$res->write(Lib::Renderer::render('scrivi-domanda.html', $data));
}

1;