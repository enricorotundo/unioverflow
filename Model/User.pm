package Model::User;
use strict;
use warnings;
use CGI::Carp;

use base 'Lib::Object';

# Metodi statici

sub getUserByUsername {
	my ($username) = @_;

	# TODO
	
	if ($username eq "user") {
		return Model::User->new(
			"username" => $username,
			"password" => "password"
		);
	} else {
		return "";
	}
}

# Oggetto

sub new {
	my ($class, @args) = @_;
	$class->SUPER::new(@args);
}

sub init {
	my ($self) = @_;
	$self->{"username"} ||= "";
	# FIXME usare hash(salt+password)
	$self->{"password"} ||= "";
}

sub checkPassword {
	my ($self, $password) = @_;

	return $self->{"password"} eq $password;
}

sub username {
	my ($self) = @_;

	return $self->{"username"};
}

1;