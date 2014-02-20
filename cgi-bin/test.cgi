#!/usr/bin/env perl
use CGI::Carp 'fatalsToBrowser';
use strict;
use warnings;
use diagnostics;

print "Content-Type: text/html\n\n";

print "<html><body>\n";
print "<b>Query String Data:</b><br/>\n";

my $query = $ENV{'QUERY_STRING'};
my @list = split( /\&/, $query);

my $var;
my $val;
foreach (@list) {
	($var, $val) = split(/=/);
	$val =~ s/\'//g;
	$val =~ s/\+/ /g;
	$val =~ s/%(\w\w)/sprintf("%c", hex($1))/ge;
	print($var, ' = ', $val, "<br/>\n");
}

print "</html></body>\n";
