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
require Controller::EseguiAccesso;
my $handler = \&Controller::EseguiAccesso::handler;

require Lib::Core;
Lib::Core::executeController($handler);
