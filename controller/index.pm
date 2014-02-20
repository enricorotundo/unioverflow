package controller::index;
use strict;
use warnings;
use diagnostics;
use lib::unioverflow;

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
