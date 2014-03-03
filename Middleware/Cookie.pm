package Middleware::Cookie;
use strict;
use warnings;
use CGI::Carp;

use CGI::Cookie;

sub handler {
	my ($req, $res) = @_;

	my %cookies = CGI::Cookie->fetch;

	$req->attr("cookie", \%cookies);
}

1;