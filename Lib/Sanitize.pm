package Lib::Sanitize;
use strict;
use warnings;
use CGI::Carp;

# Elimina tutto quello che non è una cifra tra 0 e 9
sub number {
	my ($string) = @_;
	$string = $string or "";

	$string =~s/[^0-9]//ig;

	return $string;
}

# Elimina le virgolette dalla query
sub search_query {
	my ($string) = @_;
	$string = $string or "";
	
	$string =~s/["']//ig;

	return $string;
}

# Restituisce una mail giusta o niente
sub email {
	my ($string) = @_;
	$string = $string or "";
	
	# Mettere ^ all'inizio e $ alla fine della regexp per garantire
	# che tutto rispetti la regexp, e non solo una sottostringa
	if ($string =~ m/^[a-z0-9._%+-]{1,64}\@studenti.unipd.it$/) {
		return $string
	} else {
		return ""
	}
}

# Restituisce una password giusta o niente
sub password {
	my ($string) = @_;
	$string = $string or "";
	
	# Mettere ^ all'inizio e $ alla fine della regexp per garantire
	# che tutto rispetti la regexp, e non solo una sottostringa
	if ($string =~ m/^[a-zA-Z0-9]{8,24}$/) {
		return $string;
	} else {
		return "";
	}
}

sub title {
	my ($string) = @_;
	$string = $string or "";
	
	# Va bene tutto
	return $string;
}

sub content {
	my ($string) = @_;
	$string = $string or "";
	
	# Va bene tutto
	return $string;
}

1;