package Lib::Response;
use strict;
use warnings;
use diagnostics;
use CGI::Carp;
use CGI;

use base 'Lib::Object';

sub new {
	my ($self, @args) = @_;
	$self->SUPER::new(@args);
}

sub init {
	my ($self) = @_;
	$self->{"code"} = "200";
	$self->{"content"} = "";
}

sub set_content {
	my ($self, $content) = @_;
	$self->{"content"} = $content;
}

sub send {
	my ($self) = @_;

	#my $cgi = CGI->new();
	#print
	#	$cgi->header().
	#	$self->{"content"};

	print
		"Content-Type: text/html\n\n".
		$self->{"content"};
}

1;