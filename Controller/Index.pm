package Controller::Index;
use strict;
use warnings;
use CGI::Carp;
use Lib::Renderer;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	#my $session = $request->get_session();
	#
	#$session->param("test", "TEST");
	#$session->param("asd", "ASDASD");
	#if ($request->param("key")) {
	#	$session->param("key", $request->param("key"));
	#}
	#$session->close();
	#$session->flush();

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
		"query" => $req->attr("query"),
		"path" => $req->attr("path"),
		"message" => "CGISESSID: TODO"
	};
	
	# Response
	$res->write(Lib::Renderer::render('index.html', $data));
	#$response->set_session($session);
	return $res;
}

1;