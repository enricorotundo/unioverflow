package model::user;
use strict;
use warnings;
use diagnostics;
use lib::unioverflow;

sub new {
	my $class = shift;
	my %args = @_;
	my $self = bless {}, $class;

	$self{'name'} = $args{'NAME'} || 'World';

	return $self;
}

sub view {
	# the object itself will work for the view
	return shift;
}

1;