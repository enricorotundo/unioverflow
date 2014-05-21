package Lib::Markup;
use strict;
use warnings;
use CGI::Carp;

use base 'Lib::Object';

sub convert {
	my ($text) = @_;
	# la regex ha il formato:    /originaltext/newtext/
	# my $regex =~ s/originaltext/newtext/;
	
	# TODO
	# Convertire i **...** in <emph>...</emph>

	return $text;
}

1;