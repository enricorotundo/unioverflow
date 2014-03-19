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
require Controller::Esci;
my $handler = \&Controller::Esci::handler;

require Lib::Core;
Lib::Core::executeController($handler);
