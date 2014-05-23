package Model::Question;
use strict;
use warnings;
use CGI::Carp;

use Lib::XMLCRUD;
use Lib::Config;
use Lib::Markup;
use XML::LibXML;

use base 'Lib::Object';

my $db = Lib::XMLCRUD->new( "path" => $Lib::Config::dbPath );

my $questionXPath = "/db/questions/question";
my $questionPerPage = 30;

####################
#  Metodi statici  #
####################

# recupera tutte le domande
sub getQuestions {
	my @list;
	my @questions = $db->findNodes( "/db/questions/" );

	foreach my $question (@questions)
	{

	    my $obj =  Model::Question->new(
			"id" => $question->findvalue( "\@id" ),
			"author" => $question->findvalue( "author" ),
			"title" => $question->findvalue( "title" ),
			"content" => Lib::Markup::convert($question->findvalue( "content" )),
			"status" => $question->findvalue( "status" ),
			"insertDate" => $question->findvalue( "insertDate" )
		);
		# Aggiungi uno
		push @list, $obj;
	}

	return @list;

}

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
			"content" => Lib::Markup::convert($question->findvalue( "content" )),
			"status" => $question->findvalue( "status" ),
			"insertDate" => $question->findvalue( "insertDate" )
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
	my @questions = $db->findNodes( $questionXPath );

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
		my $status = $question->findvalue( "status" );

	    my $obj = Model::Question->new(
			id => $id, 
			path => "vedi-domanda.cgi?id=" . $id, 
			title => $title, 
			author => $author,
			insertDate => $insertDate,
			status => $status
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
	my ($TestoDaCercare) = @_[1];

	my @listF;
	my $questionXPathF = "/db/questions/question[title[text()[contains(., '" . $TestoDaCercare . "')]]]";

	# recupera le domande
	my @questions = $db->findNodes( $questionXPathF );

	my @questions = sort {
    	my ($aa, $bb) = map $_->findvalue('insertDate'), ($a, $b);
    	$aa cmp $bb;
  		} $db->findNodes($questionXPathF);

	foreach my $question (@questions)
	{
		my $id = $question->findvalue( "\@id" );
		my $title = $question->findvalue( "title" );
		my $author = $question->findvalue( "author" );
		my $insertDate = $question->findvalue( "insertDate" );
		my $status = $question->findvalue( "status" );

	    my $obj = Model::Question->new(
	    	id => $id, 
			path => "vedi-domanda.cgi?id=" . $id, 
			title => $title, 
			author => $author,
			insertDate => $insertDate,
			status => $status
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

# Restituisce l'elemento XML::LibXML che descrive la domanda
sub getAsNode {
	my ($self) = @_;

	my $question = XML::LibXML::Element->new('question');

	my $id = XML::LibXML::Attr->new('id', $self->{"id"});
	my $title = XML::LibXML::Element->new('title');
	my $author = XML::LibXML::Element->new('author');
	my $content = XML::LibXML::Element->new('content');
	my $insertDate = XML::LibXML::Element->new('insertDate');
	my $status = XML::LibXML::Element->new('status');

	$id->setValue($self->{"id"});
	$title->appendTextNode($self->{"title"});
	$author->appendTextNode($self->{"author"});
	$content->appendTextNode($self->{"content"});
	$insertDate->appendTextNode($self->{"insertDate"});
	$status->appendTextNode($self->{"status"});

	$question->addChild($id);
	$question->addChild($title);
	$question->addChild($author);
	$question->addChild($content);
	$question->addChild($insertDate);
	$question->addChild($status);

	return $question;
}

sub setQuestionAsSolved {
	my ($id) = @_;

	my $question = getQuestionById($id);

	if($question) {
		$question->status = 'solved';
		return save($question);
	} else {
		return "";
	}

}

sub setQuestionAsOpened {
	my ($id) = @_;

	my $question = getQuestionById($id);

	if($question) {
		$question->status = 'opened';
		return save($question);
	} else {
		return "";
	}

}

sub insertQuestion {
	my ($title, $content, $author) = @_;
	my $DAY;
	my $MONTH;
	my $YEAR;

	($DAY, $MONTH, $YEAR) = (localtime)[3,4,5];
	$YEAR += 1900; # ritorna la data a partire dal 1900
	my $today = $YEAR . '-' . $MONTH . '-' . $DAY;

	my $newQuestion = Model::Question->new(
			title => $title, 
			author => $author,
			content => $content,
			insertDate => $today,
			status => "opened"
	);

	my $xmlQuestion = $newQuestion->getAsNode();
	$xmlQuestion->setAttribute('id', $db->getLastQuestionId() + 1);
	$db->addChild("/db/questions", $xmlQuestion);

	return $xmlQuestion->getAttribute( 'id' );
}

# Ritorna il numero totale delle domande
sub countQuestions {
	# recupera le domande
	my @questions = $db->findNodes( $questionXPath );
	return scalar(@questions);
}

# Ritorna il numero totale delle domande con Find
sub countQuestionsFind {
	# recupera le domande
	my ($TestoDaCercare) = @_[0];
	my @questionXPathF = "/db/questions/question[title[text()[contains(., '" . $TestoDaCercare . "')]]]";
	my @questions = $db->findNodes( @questionXPathF );
	return scalar(@questions);
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
	my $id = $self->{"id"};

	my $question = $db->findOne( $questionXPath . "[id = \"$id\"]" );

	if ($question) {
		$self->update()
	} else {
		# domanda non trovata
		$self->insert()
	}
}

# È da considerarsi come metodo privato, non utilizzarlo.
# Piuttosto, utilizzere il metodo save che decide se usare insert o update
sub update {
	my ($self) = @_;

	my $id = $self->{"id"};
	$db->replaceNode($questionXPath . "[id = \"$id\" ]",  $self->getAsNode());

}

# È da considerarsi come metodo privato, non utilizzarlo.
# Piuttosto, utilizzere il metodo save che decide se usare insert o update
sub insert {
	my ($self) = @_;

	$db->addChild($questionXPath, $self->getAsNode());
}


1;