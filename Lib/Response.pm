package Lib::Response;
use strict;
use warnings;
use CGI::Carp qw(warningsToBrowser);
use CGI::Cookie;

use base 'Lib::Object';

sub new {
	my ($self, @args) = @_;
	$self->SUPER::new(@args);
}

sub init {
	my ($self) = @_;
	$self->{"status"} = "200 OK";
	$self->{"content"} = "";
	$self->{"cookies"} = {};
}

sub set_content {
	my ($self, $content) = @_;
	$self->{"content"} = $content;
}

sub add_cookie {
	my ($self, $cookie) = @_;
	my $name = $cookie->name();
	$self->{"cookie"}->{$name} = $cookie;
}

sub set_session {
	my ($self, $session) = @_;
	my $SID = $session->id() || "";
	my $cookie = CGI::Cookie->new(-name => "CGISESSID", -value => $SID);
	$self->add_cookie($cookie);
}

sub send {
	my ($self) = @_;

	if ($self->{"status"}) {
		print "Status: ".$self->{"status"}."\r\n";
	}

	print "Content-Type: text/html; charset=utf-8\r\n";

	for my $cookie (values %{$self->{"cookie"}}) {
		print "Set-Cookie: ".$cookie->as_string."\n";
	}

	print "\r\n";

	print $self->{"content"};

	# Print warning as HTML comment
	warningsToBrowser(1);
}

1;