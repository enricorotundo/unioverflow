package Model::User;
use strict;
use warnings;
use CGI::Carp;

use Lib::XMLCRUD;
use Lib::Config;

use base 'Lib::Object';

my $db = Lib::XMLCRUD->new( "path" => $Lib::Config::dbPath );

####################
#  Metodi statici  #
####################

# Carica il file xml e restituisce l'oggetto dell'utente con email 'email'
# oppure "" (la stringa vuota è il false di Perl) se non esiste
# Attenzione: e se l'email che arriva contiene virgolette e caratteri strani?
# NON basta concatenare l'email alla XPath, serve fare un escape
sub getUserByEmail {
	my ($email) = @_;
	
	# Email non contiene virgolette, quindi la query XPath è sicura
	my $user = $db->findOne( "/users/user[email = \"$email\"]" );

	if ($user) {
		my $userEmail = $user->findvalue( "email" );
		my $userPassword = $user->findvalue( "password" );

		if (!($email eq $userEmail)) {
			warn "$email e $userEmail hanno valori diversi";
		}

		return Model::User->new(
			"email" => $userEmail,
			"password" => $userPassword
		);
		
	} else {
		# Utente non trovato
		return "";
	}
}

sub insertUser {
	my ($email, $password) = @_;
	my $element = {
		"email" => $email,
		"password" => $password
	}

	# $db->addChild("/users/", $element);



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