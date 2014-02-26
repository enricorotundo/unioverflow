package Lib::Request;
use strict;
use warnings;
use CGI::Carp;

use base 'Lib::Object';

sub parse_input {
	my ($buffer) = @_;
	
	my @pairs = split( /&/, $buffer);
	my $input = {};
	
	foreach my $pair (@pairs) {
		my ($name, $value) = split(/=/, $pair);
		$value ||= "";
		
		#$val =~ s/\'//g;
		#$val =~ s/\+/ /g;
		#$val =~ s/%(\w\w)/sprintf("%c", hex($1))/ge;
		#
		#$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		
		$name =~ tr/+//;
		$name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$value =~ tr/+//;
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		
		$input->{$name} = $value;
	}

	return $input;
}

sub new {
	my ($self, @args) = @_;
	$self->SUPER::new(@args);
}

sub init {
	my ($self) = @_;
	$self->{"method"} ||= "";
	$self->{"path"} ||= "";
	$self->{"query"} ||= "";
	$self->{"body"} ||= "";

	$self->{"get_parameters"} ||= {};
	$self->{"post_parameters"} ||= {};

	$self->{"get_parameters"} = parse_input($self->{"query"});
	$self->{"post_parameters"} = parse_input($self->{"body"});
}

sub method {
	my ($self) = @_;
	return $self->{"method"};
}

sub path {
	my ($self) = @_;
	return $self->{"path"};
}

sub query {
	my ($self) = @_;
	return $self->{"query"};
}

sub parameters {
	my ($self) = @_;
	return $self->{"get_parameters"};
}

sub param {
	my ($self, $name) = @_;
	return $self->{"get_parameters"}->{$name};
}

sub post_parameters {
	my ($self) = @_;
	return $self->{"post_parameters"};
}

sub post_param {
	my ($self, $name) = @_;
	return $self->{"post_parameters"}->{$name};
}

1;