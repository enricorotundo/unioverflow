package Lib::Markup;
use strict;
use warnings;
use CGI::Carp;

use base 'Lib::Object';

sub convert {
	my ($text) = @_;
	# la regex ha il formato:    /originaltext/newtext/
	# my $regex =~ s/originaltext/newtext/;

    # <strong> must go first:
    $text =~ s{ (\*\*|__) (?=\S) (.+?[*_]*) (?<=\S) \1 }
        {<strong>$2</strong>}gsx;

    $text =~ s{ (\*|_) (?=\S) (.+?) (?<=\S) \1 }
        {<em>$2</em>}gsx;

    return $text;
}

1;