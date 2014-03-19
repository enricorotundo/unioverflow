package Controller::VediDomanda;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Lib::Markup;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	# TODO ...
	
	# Execution
	my $data = {
		"title" => "Titolo domanda",
		"content" => Lib::Markup::convert("Testo della domanda con **alcune parole** in grassetto.")
	};
	
	# Response
	$res->write(Lib::Renderer::render('vedi-domanda.html', $data));
}

1;