package Unioverflow::Controller::Index;
use strict;
use warning;
use diagnostics;
use Lib::Unioverflow;

sub handler {
	# Initialization
	my $class = shift;

	# Execution
	my %dataRef = {
		"username" => "Pippo",
		"questions" => [
			{
				"title" => "Titolo domanda",
				"content" => "Contenuto del testo della domanda",
				"author" => "Paolino Paperino"
			}
		]
	}
	
	# Render
	$class->render(
		TEMPLATE => 'index.html',
		DATA     => %dataRef
	);
}
