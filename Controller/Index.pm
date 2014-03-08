package Controller::Index;
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
	$res->write(Lib::Renderer::render('index.html', $data));
}

1;