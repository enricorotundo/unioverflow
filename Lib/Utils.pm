package Lib::Utils;
use strict;
use warnings;
use CGI::Carp;

use Lib::Request;
use CGI;

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
	my $buffer = "";
	
	if($ENV{'CONTENT_LENGTH'}) {
		read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
	}
	
	my $cgi = CGI->new;
	my $params = $cgi->Vars();
	use Data::Dumper;
	warn Data::Dumper::Dumper(\$params);

	my $request = Lib::Request->new((
		"method" => ($ENV{'QUERY_METHOD'} or ""),
		"path" => ($ENV{'PATH_INFO'} or ""),
		"query" => ($ENV{'QUERY_STRING'} or ""),
		"body" => $buffer,
		"param" => $params
	));
	
	return $request;
}

1;