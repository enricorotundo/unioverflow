package Lib::Request;
use strict;
use warnings;
use CGI::Carp;

use base 'Lib::Object';

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
	$self->{"param"} ||= {};
}

sub attr {
	if (@_ == 2) {
		my ($self, $name) = @_;
		return $self->{$name};
	}
	if (@_ == 3) {
		my ($self, $name, $value) = @_;
		return $self->{$name} = $value;
	}
	die "Invalid number of parameters (".@_.")";
}

sub param {
	if (@_ == 2) {
		my ($self, $name) = @_;
		return $self->{"param"}->{$name};
	}
	if (@_ == 3) {
		my ($self, $name, $value) = @_;
		$self->{"param"}->{$name} = $value;
	}
	die "Invalid number of parameters (".@_.")";
}

1;