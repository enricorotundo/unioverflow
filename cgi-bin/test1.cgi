#!/usr/bin/env perl
use CGI::Carp 'fatalsToBrowser';
use strict;
use warnings;
use diagnostics;

use CGI;

my $cgi = new CGI;
print
$cgi->header().
$cgi->start_html( -title => 'Cgi Query String Results').
$cgi->h1('Values Passed')."\n";
my @params = $cgi->param();
print '<table border="1" cellspacing="0" cellpadding="0">'."\n";
foreach my $parameter (sort @params) {
	print "<tr><th>$parameter</th><td>" . $cgi->param($parameter) . "</td></tr>\n";
}
print "</table>\n";
print $cgi->end_html."\n";
