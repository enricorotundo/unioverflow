#!/usr/bin/env perl

BEGIN { push @INC, ".."; }

use strict;
use warnings;
use diagnostics;
use CGI::Carp;

use Lib::ErrorHandler;

require Lib::Request;
my $request = Lib::Request->new(
	"path" => $ENV{'PATH_INFO'},
	"query" => $ENV{'QUERY_STRING'},
);

require Lib::Route;
my $response = Lib::Route::handler($request);

$response->send();
