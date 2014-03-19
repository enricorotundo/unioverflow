package Controller::EseguiAccesso;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Middleware::Authentication;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	if (Middleware::Authentication::isLogged($req)) {
		$res->redirect("index.cgi");
		return;
	}
	
	Middleware::Authentication::login($req);
	
	my $message, $success;
	if (Middleware::Authentication::isLogged($req)) {
		$success = 1; # True in Perl
	} else {
		$success = ""; # False in Perl
	}
	
	# Execution
	my $data = {
		"success" => $success
	};
	
	# Response
	$res->write(Lib::Renderer::render('esegui-accesso.html', $data));
}

1;