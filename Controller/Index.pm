package Controller::Index;
use strict;
use warnings;
use diagnostics;
use CGI::Carp;
use Lib::Renderer;

sub handler {
	# Get parameters
	my ($request) = @_;

	# Execution
	my $data = {
		"username" => "Pippo",
		"questions" => [
			{
				"title" => "Titolo domanda",
				"content" => "Contenuto del testo della domanda",
				"author" => "Paolino Paperino"
			}
		],
		"query" => $request->{"query"},
		"path" => $request->get_path(),
		"parameters" => $request->get_parameters()
	};
	
	# Response
	return Lib::Renderer::render('index.html', $data);
}

1;