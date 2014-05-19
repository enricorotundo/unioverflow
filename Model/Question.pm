package Model::Question;
use strict;
use warnings;
use CGI::Carp;

use Lib::XMLCRUD;
use Lib::Config;
use XML::LibXML;

use base 'Lib::Object';

my $db = Lib::XMLCRUD->new( "path" => $Lib::Config::dbPath );

my $questionsQuery = "/db/questions/question";
my $questionPerPage = 30;

####################
#  Metodi statici  #
####################

# Carica il file xml e restituisce l'oggetto della domanda con id 'id'
# oppure "" (la stringa vuota è il false di Perl) se non esiste
# Attenzione: e se l'id che arriva contiene virgolette e caratteri strani?
# NON basta concatenare l'id alla XPath, serve fare un escape
sub getQuestionById {
	my ($id) = @_;

	# recupera la domanda
	my $question = $db->findOne( "/db/questions/question[\@id='$id']" );

	if($question){
		return Model::Question->new(
			"id" => $question->findvalue( "\@id" ),
			"author" => $question->findvalue( "author" ),
			"title" => $question->findvalue( "title" ),
			"content" => Lib::Markup::convert($question->findvalue( "content" ))
		);
	}else
	{
		# gestire errore
	}
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

	my @list;

	# recupera le domande
	my @questions = $db->findNodes( $questionsQuery );

	my @questions = sort {
    	my ($aa, $bb) = map $_->findvalue('insertDate'), ($a, $b);
    	$aa cmp $bb;
  		} $db->findNodes('/db/questions/question');

	foreach my $question (@questions)
	{
		my $id = $question->findvalue( "\@id" );
		my $title = $question->findvalue( "title" );
		my $author = $question->findvalue( "author" );
		my $insertDate = $question->findvalue( "insertDate" );

	    my $obj = Model::Question->new(
			path => "vedi-domanda.cgi?id=" . $id, 
			title => $title, 
			author => $author,
			insertDate => $insertDate
		);
		# Aggiungi uno
		push @list, $obj;
	}

	if (length(@list) <= $questionPerPage ) {
		return @list;
	}
	else{
		return @list[($page-1)*$questionPerPage .. ($page)*$questionPerPage - 1];
	}
	
}

# Restituisce tutte le domande in cui nel titolo è contenuta la stringa $TestoDaCercare passata come secondo parametro @_[1]
sub getLastQuestionsFind {

	my ($page) = @_[0];
	# Se non ci sono parametri metti 1 di default
	$page ||= 1;
	my $TestoDaCercare = @_[1];

	my @listF;
	my $questionsQueryF = "/db/questions/question[title[text()[contains(., '" . $TestoDaCercare . "')]]]";

	# recupera le domande
	my @questions = $db->findNodes( $questionsQueryF );

	my @questions = sort {
    	my ($aa, $bb) = map $_->findvalue('insertDate'), ($a, $b);
    	$aa cmp $bb;
  		} $db->findNodes($questionsQueryF);

	foreach my $question (@questions)
	{
		my $id = $question->findvalue( "\@id" );
		my $title = $question->findvalue( "title" );
		my $author = $question->findvalue( "author" );
		my $insertDate = $question->findvalue( "insertDate" );

	    my $obj = Model::Question->new(
			path => "vedi-domanda.cgi?id=" . $id, 
			title => $title, 
			author => $author,
			insertDate => $insertDate
		);
		# Aggiungi uno
		push @listF, $obj;
	}

	if (length(@listF) <= $questionPerPage ) {
		return @listF;
	}
	else{
		return @listF[($page-1)*$questionPerPage .. ($page)*$questionPerPage - 1];
	}
	
}

# Ritorna il numero totale delle domande
sub countQuestions {
	# recupera le domande
	my @questions = $db->findNodes( $questionsQuery );
	return length(@questions);
}

# Ritorna il numero totale delle domande con Find
sub countQuestionsFind {
	# recupera le domande
	my $TestoDaCercare = @_;
	my @questionsQueryF = "/db/questions/question[title[text()[contains(., '" . $TestoDaCercare . "')]]]";
	my @questions = $db->findNodes( @questionsQueryF );
	return length(@questions);
}

sub insertQuestion {
	my ($title, $content, $author) = @_;
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