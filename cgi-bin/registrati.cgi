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
require Controller::Registrati;
my $handler = \&Controller::Registrati::handler;

require Lib::Core;
Lib::Core::executeController($handler);
