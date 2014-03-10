package Lib::Core;
use strict;
use warnings;
use CGI::Carp;

require Lib::Utils;
use Lib::Response;
use Middleware::Cookie;
use Middleware::Session;
use Middleware::Authentication;

sub executeController {
	my ($handler) = @_;
	my $req = Lib::Utils::autoDetectRequest();
	my $res = Lib::Response->new();

	$res->header("Content-Type: text/html; charset=utf-8");

	Middleware::Cookie::handler($req, $res);
	Middleware::Session::handler($req, $res);
	Middleware::Authentication::handler($req, $res);
	$handler->($req, $res);

	$res->send();
}

1;
