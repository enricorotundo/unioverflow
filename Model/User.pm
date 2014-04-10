package Model::User;
use strict;
use warnings;
use CGI::Carp;

use XML::LibXML;
use Lib::Config;

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
	
	my $parser = XML::LibXML->new();
	my $doc = $parser->parse_file($Lib::Config::usersDbPath);
	my $root = $doc->documentElement();
	my $xpc = XML::LibXML::XPathContext->new($root);
	
	# Email non contiene apostrofi, quindi la query XPath è sicura
	my $xpath = "/users/user[email = \"$email\"]";
	my @user = $xpc->findnodes( $xpath );

	if ($user[0]) {
		my $xmlEmail = $user[0]->findnodes( "email" );
		my $xmlPwd = $user[0]->findnodes( "password" );

		if (!($email eq $xmlEmail)) {
			warn "$email e $xmlEmail hanno valori diversi";
		}

		return Model::User->new(
			"email" => $xmlEmail,
			"password" => $xmlPwd
		);
		
	} else {
		# Utente non trovato
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