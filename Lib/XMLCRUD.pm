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
	if (!defined($self->{"path"})) die "A path must be specified";
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

sub loadFindXPath {
	my ($self) = @_;
	
	my $doc = $self->loadDoc();
	my $root = $doc->documentElement();
	my $xpc = XML::LibXML::XPathContext->new($root);
	my $result = $xpc->find( $xpath );

	return ($doc, $result);
}

sub loadFindNodesXPath {
	my ($self) = @_;
	
	my $doc = $self->loadDoc();
	my $root = $doc->documentElement();
	my $xpc = XML::LibXML::XPathContext->new($root);
	my @result = $xpc->findnodes( $xpath );

	return ($doc, @result);
}

############
#  CREATE  #
############

sub addChild {
	my ($self, $xpath, $element) = @_;
	
	my ($doc, $result) = loadFindXPath( $xpath );

	$result->addChild($element);

	$self->saveDoc($doc);
}

############
#   READ   #
############

sub findNodes {
	my ($self, $xpath) = @_;
	
	my ($doc, @result) = loadFindNodesXPath( $xpath );

	return @result;
}

sub find {
	my ($self, $xpath) = @_;
	
	my ($doc, $result) = loadFindXPath( $xpath );
	
	return $result;
}

############
#  UPDATE  #
############

# Delete and Insert
sub replaceNode {
	my ($self, $xpath, $element) = @_;
	
	my ($doc, $result) = loadFindXPath( $xpath );
	
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
	
	my ($doc, $result) = loadFindXPath( $xpath );
	
	my $parent = $result->parentNode;
	$parent->removeChild($result);

	$self->saveDoc($doc);
}

1;