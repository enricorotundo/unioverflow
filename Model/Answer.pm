package Model::Answer;
use strict;
use warnings;
use CGI::Carp;

use Lib::XMLCRUD;
use Lib::Config;
use Lib::Markup;
use XML::LibXML;

use base 'Lib::Object';

my $db = Lib::XMLCRUD->new( "path" => $Lib::Config::dbPath );

my $answerXPath = "/db/answers/answer";

####################
#  Metodi statici  #
####################

# Carica il file xml e restituisce l'oggetto della risposta con id 'id'
# oppure "" (la stringa vuota è il false di Perl) se non esiste
# Attenzione: e se l'id che arriva contiene virgolette e caratteri strani?
# NON basta concatenare l'id alla XPath, serve fare un escape
sub getAnswerById {
	my ($id) = @_;

	# recupera la domanda
	my $answer = $db->findOne( $answerXPath . "[\@id='$id']" );

	if($answer){
		return Model::Answer->new(
			"id" => $answer->findvalue( "\@id" ),
			"content" => Lib::Markup::convert($answer->findvalue( "content" )),
			"author" => $answer->findvalue( "author" ),
			"question" => $answer->findvalue( "question" ),
			"insertDate" => $answer->findvalue( "insertDate" )
		);
	}else
	{
		# gestire errore
	}
}

# Carica il file xml e restituisce l'oggetto delle risposte alla domanda 
# con id 'id'
sub getAnswersByQuestionId {
	my ($id) = @_;
	my @list;

	if (defined $id) {



		# recupera le risposte
		my @answers = $db->findNodes( $answerXPath . "[question = $id]" );

		foreach my $answer (@answers)
		{
			my $id = $answer->findvalue( "\@id" );
			my $content = Lib::Markup::convert($answer->findvalue( "content" ));
			my $author = $answer->findvalue( "author" );
			my $question = $answer->findvalue( "question" );
			my $insertDate = $answer->findvalue( "insertDate" );

		    my $obj = Model::Answer->new(
				id => $id, 
				content => $content, 
				author => $author,
				question => $question,
				insertDate => $insertDate
			);
			# Aggiungi uno
			push @list, $obj;
		}
	} 

	return @list;
}

# Restituisce l'elemento XML::LibXML che descrive la risposta
sub getAsNode {
	my ($self) = @_;

	my $answer = XML::LibXML::Element->new('answer');

	my $id = XML::LibXML::Attr->new('id', $self->{"id"});
	my $author = XML::LibXML::Element->new('author');
	my $content = XML::LibXML::Element->new('content');
	my $insertDate = XML::LibXML::Element->new('insertDate');
	my $question = XML::LibXML::Element->new('question');

	$id->setValue($self->{"id"});
	$content->appendTextNode($self->{"content"});
	$author->appendTextNode($self->{"author"});
	$question->appendTextNode($self->{"question"});
	$insertDate->appendTextNode($self->{"insertDate"});

	$answer->addChild($id);
	$answer->addChild($content);
	$answer->addChild($author);
	$answer->addChild($question);
	$answer->addChild($insertDate);
	
	return $answer;
}

sub insertAnswer {
	my ($questionId, $content, $author) = @_;
	my $DAY;
	my $MONTH;
	my $YEAR;

	($DAY, $MONTH, $YEAR) = (localtime)[3,4,5];
	$YEAR += 1900; # ritorna la data a partire dal 1900
	my $today = $YEAR . '-' . $MONTH . '-' . $DAY;

	my $newAnswer = Model::Answer->new(
			content => $content, 
			author => $author,
			question => $questionId,
			insertDate => $today
	);

	my $xmlAnswer = $newAnswer->getAsNode();
	$xmlAnswer->setAttribute('id', $db->getLastAnswerId() + 1);
	$db->addChild("/db/answers", $xmlAnswer);

	return $xmlAnswer->getAttribute( 'id' );
}

# Ritorna il numero totale delle risposte a una domanda
sub countAnswersOfAQuestion {
	my ($id) = @_;

	# recupera le risposte
	my @answer = $db->findNodes( $answerXPath . "[question = \"$id\"]" );
	return scalar(@answer);
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

	my $answer = $db->findOne( $answerXPath . "[id = \"$id\"]" );

	if ($answer) {
		$self->update()
	} else {
		# risposta non trovata
		$self->insert()
	}
}

# È da considerarsi come metodo privato, non utilizzarlo.
# Piuttosto, utilizzere il metodo save che decide se usare insert o update
sub update {
	my ($self) = @_;

	my $id = $self->{"id"};
	$db->replaceNode($answerXPath . "[id = \"$id\" ]",  $self->getAsNode());

}

# È da considerarsi come metodo privato, non utilizzarlo.
# Piuttosto, utilizzere il metodo save che decide se usare insert o update
sub insert {
	my ($self) = @_;

	$db->addChild($answerXPath, $self->getAsNode());
}


1;