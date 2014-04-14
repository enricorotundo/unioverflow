package Lib::Utils;
use strict;
use warnings;
use CGI::Carp;

use Lib::Request;
use CGI;
use Fcntl qw(:flock SEEK_END);

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
		"method" => ($ENV{'QUERY_METHOD'} or ""),
		"path" => ($ENV{'PATH_INFO'} or ""),
		"query" => ($ENV{'QUERY_STRING'} or ""),
		"param" => $params
	));
	
	return $request;
}

# Sovrascrive il file usando i lock
sub safeWriteFile {
	my ($filename, $content) = @_;
	
	open my $fh, '>', $filename  or die $!;
	# drop all PerlIO layers possibly created by a use open pragma
	binmode $fh;
	
	# lock the file refered by the handle
	flock($fh, LOCK_EX) or die "Cannot lock the file - $!\n";
	# and, in case someone appended while we were waiting...
	seek($fh, 0, SEEK_END) or die "Cannot seek - $!\n";

	print {$fh} $content;

	flock($fh, LOCK_UN) or die "Cannot unlock the file - $!\n";
	
	close($fh);
}

1;