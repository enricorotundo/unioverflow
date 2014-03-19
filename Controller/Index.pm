package Controller::Index;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Middleware::Authentication;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	my $logged = "No";
	
	if (Middleware::Authentication::isLogged($req)) {
		$logged = "Sì: ".$req->attr("user")->username;
	}

	# Execution
	my $data = {
		"username" => "Pippo",
		"logged" => Middleware::Authentication::isLogged($req)
	};

	# Response
	$res->write(Lib::Renderer::render('index.html', $data));
}

1;