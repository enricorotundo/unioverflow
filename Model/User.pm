package Model::User;
use strict;
use warnings;
use CGI::Carp;

use Lib::XMLCRUD;
use Lib::Config;
use XML::LibXML;

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
	my $user = $db->findOne( "/db/users/user[email = \"$email\"]" );

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

# recupera tutti gli utenti
sub getUsers {
	my @list;
	my @users = $db->findNodes( "/db/users/*" );

	foreach my $user (@users)
	{
		my $email = $user->findvalue( "email" );
		my $password = $user->findvalue( "password" );

	    my $obj = Model::User->new(
			email => $email, 
			password => $password
		);
		# Aggiungi uno
		push @list, $obj;
	}

	return @list;
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

# Restituisce l'elemento XML::LibXML che descrive l'utente
sub getAsNode {
	my ($self) = @_;

	my $user = XML::LibXML::Element->new('user');
	my $email = XML::LibXML::Element->new('email');
	$email->appendTextNode($self->{"email"});
	my $password = XML::LibXML::Element->new('password');
	$password->appendTextNode($self->{"password"});
	$user->addChild($email);
	$user->addChild($password);

	return $user
}

# Salva l'oggetto nel database xml
# Se è già presente qualcuno con l'email $self->{"email"} lo sovrascrive
sub save {
	my ($self) = @_;
	
	# Email non contiene virgolette, quindi la query XPath è sicura
	my $email = $self->{"email"};
	my $user = $db->findOne( "/db/users/user[email = \"$email\"]" );

	if ($user) {
		$self->update()
	} else {
		# Utente non trovato
		$self->insert()
	}
}

# È da considerarsi come metodo privato, non utilizzarlo.
# Piuttosto, utilizzere il metodo save che decide se usare insero o update
sub update {
	my ($self) = @_;

	# Email non contiene virgolette, quindi la query XPath è sicura
	my $email = $self->{"email"};
	$db->replaceNode("/db/users/user[email = \"$email\"]", $self->getAsNode());
}

# È da considerarsi come metodo privato, non utilizzarlo.
# Piuttosto, utilizzere il metodo save che decide se usare insero o update
sub insert {
	my ($self) = @_;

	$db->addChild("/db/users", $self->getAsNode());
}

1;