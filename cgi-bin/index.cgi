#!/usr/bin/env perl

BEGIN { push @INC, ".."; }

use strict;
use warning;
use diagnostics;
use Unioverflow;

use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use CGI qw(:standard);

# Execute page

require Controller::Index;
Controller::Index->handler();
