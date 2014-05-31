package Lib::Utils;
use strict;
use warnings;
use CGI::Carp;

use Lib::Request;
use CGI;
use Fcntl qw(:flock SEEK_END);
# use HTML::Entities;

sub parse_input {
	die
	my ($buffer) = @_;
	
	my @pairs = split( /&/, $buffer);
	my $input = {};
	
	foreach my $pair (@pairs) {
		my ($name, $value) = split(/=/, $pair);
		$value ||= "";
		
		#$val =~ s/\'//g;
		#$val =~ s/\+/ /g;
		#$val =~ s/%(\w\w)/sprintf("%c", hex($1))/ge;
		#
		#$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		
		$name =~ tr/+//;
		$name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$value =~ tr/+//;
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		
		$input->{$name} = $value;
	}

	return $input;
}

sub autoDetectRequest {
	my $cgi = CGI->new;
	my $params = $cgi->Vars();
	use Data::Dumper;
	warn Data::Dumper::Dumper(\$params);

	my $request = Lib::Request->new((
		"method" => ($ENV{'REQUEST_METHOD'} or ""),
		"path" => ($ENV{'PATH_INFO'} or ""),
		"query" => ($ENV{'QUERY_STRING'} or ""),
		"param" => $params
	));
	
	return $request;
}

# Sovrascrive il file usando i lock
sub safeWriteFile {
	my ($filename, $content) = @_;
	
	if ($filename =~ /^([^\0]+)$/) {
		$filename = $1;

		# se genera "permission denied" va usato il comando "make" che sistema i permessi	 
		open my $fh, '>', $filename or die $!; 

		# drop all PerlIO layers possibly created by a use open pragma
		binmode $fh;
		
		# lock the file refered by the handle
		flock($fh, LOCK_EX) or die "Cannot lock the file - $!\n";
		# and, in case someone appended while we were waiting...
		seek($fh, 0, SEEK_END) or die "Cannot seek - $!\n";

		print {$fh} $content;

		flock($fh, LOCK_UN) or die "Cannot unlock the file - $!\n";
		
		close($fh);
	} else {
		die "Cannot open the file $filename because it contains null characters\n";
	}
}


# Controlla che la stringa non sia dannosa
sub textSecurityCheck {
	my ($text) = @_;

	# TODO ...

	return $text;
}


# Replace dei caratteri speciali che non validano l'XML
sub replaceHTMLChars {
	my ($text) = @_;

	# $text = replace("&","&amp;",$text);
	$text = replace('"',"&quot;",$text);
	$text = replace("'","&apos;",$text);
	$text = replace("<","&lt;",$text);
	$text = replace(">","&gt;",$text);

	# encode_entities($text, "\200-\377"); # usa use HTML::Entities da decommentare

	return $text;
}


sub replace {
	my ($from,$to,$string) = @_;
	$string =~s/$from/$to/ig;

	return $string;
}

# Restituisce la stringa senza gli spazi all'inizio e alla fine
# es. "   na na na na batman   " --> "na na na na batman"
sub trim {
	my ($string) = @_;
	$string =~ s/^\s+//g;
	$string =~ s/\s+$//g;
	return $string;
}

sub not_empty {
	my ($string) = @_;
	$string = trim($string);
	return (($string ne "") || (length $string > 1))
}

1;