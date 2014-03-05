package Middleware::Session;
use strict;
use warnings;
use CGI::Carp;

use CGI::Session;

sub handler {
	my ($req, $res) = @_;

	my $session = getSession($req);
	if (!$session) {
		$session = createSession();
		$req->attr("cookie")->set("CGISESSID", $session->id());
	}
	
	# TODO: distruggi sessione

	$req->attr("session", $session);
}

sub getSession {
	my ($request) = @_;
	
	my $session = CGI::Session->load($request->attr("cookie")->get("CGISESSID")) or die CGI::Session->errstr;
	if ($session->is_expired || $session->is_empty) {
		return undef;
	} else {
		return $session;
	}
}

sub destroySession {
	my $session = CGI::Session->load() or die CGI::Session->errstr;
	my $SID = $session->id();
	$session->close();
	$session->delete();
	$session->flush();
}

sub saveSession {
	my ($session) = @_;
	
	$session->close();
	$session->flush();
}

sub createSession {
	my $session = CGI::Session->new();
	return $session;
}

1;