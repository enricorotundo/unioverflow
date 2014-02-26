package Controller::Index;
use strict;
use warnings;
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
		"query" => $request->query(),
		"path" => $request->path(),
		"parameters" => $request->parameters()
	};
	
	# Response
	return Lib::Renderer::render('index.html', $data);
}

1;