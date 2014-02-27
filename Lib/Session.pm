package Lib::Session;
use strict;
use warnings;
use CGI::Carp;
use CGI::Session;

sub getSession {
	my ($request) = @_;
	
	my $session = CGI::Session->load($request->cookie("CGISESSID")->value()) or die CGI::Session->errstr;
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
sub getOrCreateSession {
	my ($request) = @_;
	
	my $session = CGI::Session->new($request->cookie("CGISESSID")->value());
	return $session;
}

1;