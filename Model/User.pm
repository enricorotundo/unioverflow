package Model::User;
use strict;
use warnings;
use CGI::Carp;

use base 'Lib::Object';

####################
#  Metodi statici  #
####################

# Carica il file xml e restituisce l'oggetto dell'utente con email 'email'
# oppure "" (la stringa vuota è il false di Perl) se non esiste
# Attenzione: e se l'email che arriva contiene virgolette e caratteri strani?
# NON basta concatenare l'email alla XPath, serve fare un escape
sub getUserByEmail {
	my ($email) = @_;

	# TODO

	if ($email eq "user") {
		return Model::User->new(
			"email" => $email,
			"password" => "password"
		);
	} else {
		return "";
	}
}

#############
#  Oggetto  #
#############

sub new {
	my ($class, @args) = @_;
	$class->SUPER::new(@args);
}

sub init {
	my ($self) = @_;
	$self->{"email"} ||= "";
	$self->{"password"} ||= "";
}

sub checkPassword {
	my ($self, $password) = @_;

	return $self->{"password"} eq $password;
}

sub email {
	my ($self) = @_;

	return $self->{"email"};
}

# Salva l'oggetto nel database xml
# Se è già presente qualcuno con l'email $self->{"email"} lo sovrascrive
sub save {
	my ($self) = @_;

	# TODO (quando ce ne sarà bisogno)
}

1;