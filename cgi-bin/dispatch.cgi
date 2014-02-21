#!/usr/bin/env perl

# Include project path
BEGIN { push @INC, ".."; }

# More strict
use strict;
use warnings;
use diagnostics;
use CGI::Carp;

# Redirect errors to log file
use Lib::Config
close STDERR;
open STDERR, '>>', $Lib::Config::logFile;

# Show errors via browser
use Lib::ErrorHandler;

# Execute

require Lib::Request;
my $request = Lib::Request->new(
	"path" => $ENV{'PATH_INFO'},
	"query" => $ENV{'QUERY_STRING'},
);

require Lib::Route;
my $response s= Lib::Route::handler($request);

$response->send();
