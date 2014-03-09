package Lib::Response;
use strict;
use warnings;
use CGI::Carp;

use CGI::Carp qw(warningsToBrowser);

use base 'Lib::Object';

sub new {
	my ($self, @args) = @_;
	$self->SUPER::new(@args);
}

sub init {
	my ($self) = @_;
	$self->{"header"} ||= "";
	$self->{"content"} ||= "";
	$self->{"cookie"} ||= {};
}

sub header {
	my ($self, $data) = @_;
	$self->{"header"} .= $data."\r\n";
}

sub cookie {
	my ($self, $cookie) = @_;
	$self->{"cookie"} = $cookie;
}

sub write {
	my ($self, $data) = @_;
	$self->{"content"} .= $data;
}

sub send {
	my ($self) = @_;
	
	print $self->{"header"};
	for my $cookie (values %{$self->{"cookie"}->all()}) {
		print "Set-Cookie: ",$cookie->as_string,"\n";
	}
	print "\r\n";
	print $self->{"content"};

	# Print warning as HTML comment
	warningsToBrowser(1);
}

1;