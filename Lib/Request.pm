package Lib::Request;
use strict;
use warnings;
use CGI::Carp;
use Lib::Utils;
use Lib::Session;

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
	$self->{"cookies"} ||= [];

	$self->{"get_parameters"} ||= {};
	$self->{"post_parameters"} ||= {};

	$self->{"get_parameters"} = Lib::Utils::parse_input($self->{"query"});
	$self->{"post_parameters"} = Lib::Utils::parse_input($self->{"body"});
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

sub cookie {
	my ($self, $name) = @_;
	return $self->{"cookies"}->{$name};
}

sub post_parameters {
	my ($self) = @_;
	return $self->{"post_parameters"};
}

sub post_param {
	my ($self, $name) = @_;
	return $self->{"post_parameters"}->{$name};
}

sub get_session {
	my ($self) = @_;
	return Lib::Session::getOrCreateSession($self);
}

1;