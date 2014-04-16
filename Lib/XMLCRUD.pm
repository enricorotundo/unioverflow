package Lib::XMLCRUD;
use strict;
use warnings;
use CGI::Carp;

use XML::LibXML;
use Lib::Utils;

use base 'Lib::Object';

sub new {
	my ($self, %args) = @_;
	$self->SUPER::new(%args);
}

sub init {
	my ($self) = @_;
	if (!defined($self->{"path"})) {
		die "A path must be specified ", $self->{"path"};
	}
}

################
#  LOAD, SAVE  #
################

sub loadDoc {
	my ($self) = @_;
	
	my $parser = XML::LibXML->new();
	my $doc = $parser->parse_file($self->{"path"});

	return $doc;
}

sub saveDoc {
	my ($self, $doc) = @_;
	
	Lib::Utils::safeWriteFile($self->{"path"}, $doc->toString);
}

sub loadFindNodesXPath {
	my ($self, $xpath) = @_;
	
	my $doc = $self->loadDoc();
	my $root = $doc->documentElement();
	my $xpc = XML::LibXML::XPathContext->new($root);
	my @result = $xpc->findnodes( $xpath );

	return ($doc, @result);
}

# Restituisce il nodo corrispondente all'xpath oppure undef se non ce ne sono.
# Se ce ne sono più di uno genera un errore
sub loadFindOneXPath {
	my ($self, $xpath) = @_;
	
	my ($doc, @result) = $self->loadFindNodesXPath($xpath);
	
	if (scalar @result > 1) {
		die "Too many results for $xpath";
	}

	if (scalar @result eq 0) {
		return undef;
	} else {
		return ($doc, $result[0]);
	}
}

############
#  CREATE  #
############

sub addChild {
	my ($self, $xpath, $element) = @_;
	
	my ($doc, $result) = $self->loadFindXPath( $xpath );

	$result->addChild($element);

	$self->saveDoc($doc);
}

############
#   READ   #
############

sub findNodes {
	my ($self, $xpath) = @_;
	
	my ($doc, @result) = $self->loadFindNodesXPath( $xpath );

	return @result;
}

sub findOne {
	my ($self, $xpath) = @_;
	
	my ($doc, $result) = $self->loadFindOneXPath( $xpath );
	
	return $result;
}

############
#  UPDATE  #
############

# Delete and Insert
sub replaceNode {
	my ($self, $xpath, $element) = @_;
	
	my ($doc, $result) = $self->loadFindXPath( $xpath );
	
	my $parent = $result->parentNode;
	$parent->removeChild($result);
	$parent->addChild($element);
	
	$self->saveDoc($doc);
}

############
#  DELETE  #
############

sub deleteNode {
	my ($self, $xpath) = @_;
	
	my ($doc, $result) = $self->loadFindXPath( $xpath );
	
	my $parent = $result->parentNode;
	$parent->removeChild($result);

	$self->saveDoc($doc);
}

1;