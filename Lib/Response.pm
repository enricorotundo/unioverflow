package Lib::Response;
use strict;
use warnings;
use CGI::Carp qw(warningsToBrowser);
use CGI;

use base 'Lib::Object';

sub new {
	my ($self, @args) = @_;
	$self->SUPER::new(@args);
}

sub init {
	my ($self) = @_;
	$self->{"status"} = "200 OK";
	$self->{"content"} = "";
}

sub set_content {
	my ($self, $content) = @_;
	$self->{"content"} = $content;
}

sub send {
	my ($self) = @_;

	print
		"Status: ".$self->{"status"}."\r\n".
		"Content-Type: text/html; charset=utf-8\r\n".
		"\r\n".
		$self->{"content"};

	# Print warning as HTML comment
	warningsToBrowser(1);
}

1;