package Lib::Markup;
use strict;
use warnings;
use CGI::Carp;

use HTML::Entities;

# Input: testo grezzo, senza codifica html, con formattazione markup e a-capo
# Output: codice html pronto per essere inviato al browser
sub convert {
	my ($text) = @_;

	# Codifica i caratteri speciali dell'html
	$text = encode_entities($test)

	# la regex ha il formato:    /originaltext/newtext/
	# my $regex =~ s/originaltext/newtext/;

	# <strong>, va per primo
	$text =~ s{ (\*\*) (?=\S) (.+?[*]*) (?<=\S) \1 }{<strong>$2</strong>}gsx;

	# <em>
	$text =~ s{ (\*) (?=\S) (.+?) (?<=\S) \1 }{<em>$2</em>}gsx;

	# Codifica gli a-capo
	# mi raccomando: rimpiazzare prima \r\n e poi \n, \r
	$text =~ s/\r\n/<br\/>/g;
	$text =~ s/\n|\r/<br\/>/g;

	return $text;
}

1;