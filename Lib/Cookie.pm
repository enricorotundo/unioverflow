package Lib::Cookie;
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
	$self->{"cookie"} ||= {};
}

sub exists {
	my ($self, $name) = @_;

	my $cookie = $self->{"cookie"}->{$name};
	if ($cookie) {
		return 1;
	} else {
		return "";
	}
}

sub get {
	my ($self, $name) = @_;

	if ($self->exists($name)) {
		return $self->{"cookie"}->{$name}->value();
	} else {
		return undef;
	}
}

sub set {
	my ($self, $name, $value) = @_;

	if ($self->exists($name)) {
		return $self->{"cookie"}->{$name}->value($value);
	} else {
		my $cookie = CGI::Cookie->new(-name => $name, -value => $value);
		$self->{"cookie"}->{$name} = $cookie;
	}
}

sub delete {
	my ($self, $name) = @_;

	$self->set("");
	# TODO: imposta data di scadenza nel passato
}

1;