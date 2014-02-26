#!/usr/bin/perl -wT

# Include project path
BEGIN { push @INC, ".."; }

# More strict
use strict;
use warnings;
use CGI::Carp;

# Show errors via browser
use Lib::ErrorHandler;

# Execute

my $buffer;
read (STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

require Lib::Request;
my $request = Lib::Request->new(
	"method" => $ENV{'QUERY_METHOD'},
	"path" => $ENV{'PATH_INFO'},
	"query" => $ENV{'QUERY_STRING'},
	"body" => $buffer
);

require Controller::Index;
my $response = Controller::Index::handler($request);

$response->send();
