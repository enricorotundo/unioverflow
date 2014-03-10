package Middleware::Cookie;
use strict;
use warnings;
use CGI::Carp;

use CGI::Cookie;
use Lib::Cookie;

# Carica il dizionario dei cookie in $req->attr("cookie")

sub handler {
	my ($req, $res) = @_;
	
	my %cookie_hash = CGI::Cookie->fetch;
	my $cookie = Lib::Cookie->new("cookie" => \%cookie_hash);
	
	$req->attr("cookie", $cookie);
	$res->cookie($cookie);
}

1;