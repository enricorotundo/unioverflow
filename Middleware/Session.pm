package Middleware::Session;
use strict;
use warnings;
use CGI::Carp;

use CGI::Session;

# Se è arrivato un cookie di sessione, carica la sessione
# Altrimenti, crea una nuova sessione
# La sessione viene memorizzata in $req->attr("session")
# Per chiudere la sessione basta usare Middleware::Session::destroySession(req)

sub handler {
	my ($req, $res) = @_;

	my $session = getSession($req);
	if (!$session) {
		$session = createSession($req);
	}
	$req->attr("session", $session);
	
	# Passa la funzione per distruggere la sessione
	$req->attr("destroySession", \&destroySession);
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

sub createSession {
	my ($request) = @_;
	
	my $session = CGI::Session->new();
	$session->expire('3h');
	$request->attr("cookie")->set("CGISESSID", $session->id());
	$session->param("email", $request->param("email"));
	return $session;
}

sub destroySession {
	my ($request) = @_;
	
	my $session = $request->attr("session");
	if ($session) {
		$session->close();
		$session->delete();
		$session->flush();
		$request->attr("cookie")->delete("CGISESSID");
	}
}

1;