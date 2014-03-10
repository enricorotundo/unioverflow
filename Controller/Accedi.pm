package Controller::Accedi;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Middleware::Authentication;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	if ($req->{"isLogged"}) {
		$res->redirect("index.cgi");
		return;
	}

	Middleware::Authentication::login($req);

	my $message;
	if ($req->{"isLogged"}) {
		$message = "Login OK";
	} else {
		$message = "Login ERROR";
	}

	# Execution
	my $data = {
		"username" => "Pippo",
		"message" => $message
	};

	# Response
	$res->write(Lib::Renderer::render('accedi.html', $data));
}

1;