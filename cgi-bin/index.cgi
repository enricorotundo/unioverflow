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
require Lib::Utils;
my $request = Lib::Utils::autoDetectRequest();

require Controller::Index;
my $response = Controller::Index::handler($request);

$response->send();
