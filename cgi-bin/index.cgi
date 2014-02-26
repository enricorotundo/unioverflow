#!/usr/bin/env perl

# Include project path
BEGIN { push @INC, ".."; }

# More strict
use strict;
use warnings;
use CGI::Carp;

# Show errors via browser
use Lib::ErrorHandler;

# Execute

require Lib::Request;
my $request = Lib::Request->new(
	"path" => $ENV{'PATH_INFO'},
	"query" => $ENV{'QUERY_STRING'},
);

require Controller::Index;
my $response = Controller::Index::handler($request);

$response->send();
