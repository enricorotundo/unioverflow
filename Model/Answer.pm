package Model::Answer;
use strict;
use warnings;
use CGI::Carp;

use base 'Lib::Object';

####################
#  Metodi statici  #
####################

# Carica il file xml e restituisce l'oggetto della risposta con id 'id'
# oppure "" (la stringa vuota è il false di Perl) se non esiste
# Attenzione: e se l'id che arriva contiene virgolette e caratteri strani?
# NON basta concatenare l'id alla XPath, serve fare un escape
sub getAnswerById {
	my ($id) = @_;

	# TODO

	return Model::Answer->new(
		"id" => $id
		# TODO ecc ecc
	);
}

# Carica il file xml e restituisce l'oggetto delle risposte alla domanda 
# con id 'id'
sub getAnswersByQuestionId {
	# TODO
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
	$self->{"id"} ||= "";
	# TODO ecc ecc
}

# Salva l'oggetto nel database xml
# Se è già presente qualcuno con l'id $self->{"id"} lo sovrascrive
sub save {
	my ($self) = @_;

	# TODO (quando ce ne sarà bisogno)
}

1;