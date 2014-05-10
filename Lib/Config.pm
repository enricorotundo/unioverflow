package Lib::Config;
use strict;
use warnings;
use CGI::Carp;

use File::Spec;
use File::Basename;

# Path assoluta della cartella contenente tutto il progetto
our $rootPath = File::Spec->rel2abs(dirname(__FILE__)."/..")."/";

# Path assoluta della cartella dei template
our $templatePath = $rootPath."View/";

# Path assoluta della cartella dei template
our $usersDbPath = $rootPath."db/users.xml";

# Path assoluta della cartella dei template
our $dbPath = $rootPath."db/db.xml";

1;