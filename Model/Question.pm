package Model::Question;
use strict;
use warnings;
use CGI::Carp;

use base 'Lib::Object';

####################
#  Metodi statici  #
####################

# Carica il file xml e restituisce l'oggetto della domanda con id 'id'
# oppure "" (la stringa vuota è il false di Perl) se non esiste
# Attenzione: e se l'id che arriva contiene virgolette e caratteri strani?
# NON basta concatenare l'id alla XPath, serve fare un escape
sub getQuestionById {
	my ($id) = @_;

	# TODO

	return Model::Question->new(
		"id" => $id
		# TODO ecc ecc
	);
}

# Ordina tutte le domande per data (o per id...) e ne restituisce $questionPerPage
# quelle che vanno dalla numero ($page-1)*$questionPerPage (esclusa) alla ($page)*$questionPerPage (inclusa)
# es.
# $page = 2
# $questionPerPage = 30
# risposta:
#   array di 30 elementi (o meno se non ci sono abbastanza domande)
#   con le domande dalla numero 31 alla 60 (cioè dalla 30, esclusa, alla 60, inclusa)
# Attenzione: numero non vuol dire id! Vuol dire numerarle dopo averle ordinate
sub getLastQuestions {
	my ($page) = @_;
	# Se non ci sono parametri metti 1 di default
	$page ||= 1;

	my $questionPerPage = 30;

	# TODO

	my $list = []

	my obj = Model::Answer->new(
		"id" => $id
		# TODO ecc ecc
	);

	# Aggiungi uno
	push @$list, $obj;
	
	return $list;
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