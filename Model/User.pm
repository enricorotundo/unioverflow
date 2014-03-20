package Model::User;

# Include project path
BEGIN { push @INC, ".."; }

use strict;
use warnings;
use CGI::Carp;
use XML::LibXML;

use base 'Lib::Object';

my $filename = '../db/users.xml';


####################
#  Metodi statici  #
####################

# Carica il file xml e restituisce l'oggetto dell'utente con email 'email'
# oppure "" (la stringa vuota è il false di Perl) se non esiste
# Attenzione: e se l'email che arriva contiene virgolette e caratteri strani?
# NON basta concatenare l'email alla XPath, serve fare un escape
sub getUserByEmail {
	my ($email) = @_;
	# inserisco il carattere backlash prima della @ in email????
	my @splittedMail = split('@', $email);

	$email= $splittedMail[0] . '@' . $splittedMail[1]; # se inserisco la \ come escape non funzione la query xpath!!!

	my $parser = XML::LibXML->new();
	my $doc = $parser->parse_file($filename);
	my $root = $doc->documentElement();
	my $xpc = XML::LibXML::XPathContext->new($root);
	my $xpath = "/users/user[email = \"$email\"]";
	my @user = $xpc->findnodes( $xpath );

	my $xmlEmail = $user[0]->findnodes( "email" );
	my $xmlPwd = $user[0]->findnodes( "password" );

	if ($email eq $xmlEmail) {
		return Model::User->new(
			"email" => $xmlEmail,
			"password" => $xmlPwd
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

#TODO
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