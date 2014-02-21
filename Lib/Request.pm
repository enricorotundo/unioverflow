package Lib::Request;
use strict;
use warnings;
use diagnostics;
use CGI::Carp;

use base 'Lib::Object';

sub new {
	my ($self, @args) = @_;
	$self->SUPER::new(@args);
}

sub init {
	my ($self) = @_;
	$self->{"query"} ||= "";
	$self->{"path"} ||= "";
	$self->{"parameters"} ||= {};

	$self->parse_query();
}

sub parse_query {
	my ($self) = @_;

	my @pairs = split( /\&/, $self->{"query"});
	my $parameters = {};
	
	foreach (@pairs) {
		my ($name, $value) = split(/=/);
		$value ||= "";
		
		#$val =~ s/\'//g;
		#$val =~ s/\+/ /g;
		#$val =~ s/%(\w\w)/sprintf("%c", hex($1))/ge;
		
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$parameters->{$name} = $value;
	}

	$self->{"parameters"} = $parameters;
}

sub get_path {
	my ($self) = @_;
	return $self->{"path"};
}

sub get_query {
	my ($self) = @_;
	return $self->{"path"};
}

sub get_parameters {
	my ($self) = @_;
	return $self->{"parameters"};
}

sub get_parameter {
	my ($self, $name) = @_;
	return $self->{"parameters"}->{$name};
}

1;