#!/usr/bin/perl

use strict;
use warnings;
use XML::LibXML;

my $filename = 'users.xml';

my $parser = XML::LibXML->new();
my $doc = $parser->parse_file($filename);
my $xc = XML::LibXML::XPathContext->new( $doc->documentElement() );
$xc->registerNs( ns => 'http://www.unioverflow.com' );

# $xc->findvalue( q{ /ns:users/ns:user } );

my @users = $xc->findnodes( q{ /ns:users/ns:user/ns:email } ); 

foreach my $user (@users) {
	print $user->to_literal, "\n";
}
