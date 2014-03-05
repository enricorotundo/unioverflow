package Controller::Index;
use strict;
use warnings;
use CGI::Carp;
use Lib::Renderer;
use Middleware::Session;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	my $session = $req->attr("session");
	my $destroySession = $req->attr("destroySession");
	
	$session->param("test", "TEST");
	$session->param("asd", "ASDASD");
	if ($req->param("key")) {
		$session->param("key", $req->param("key"));
	}
	
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
		"message" => "Session test: ".$session->param("test")."   Cookie CGISESSID: ".$req->attr("cookie")->get("CGISESSID")
	};
	
	&$destroySession($req);
	
	# Response
	$res->write(Lib::Renderer::render('index.html', $data));
	return $res;
}

1;