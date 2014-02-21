package Model::User;
use strict;
use warnings;
use diagnostics;
use CGI::Carp;

use base 'Lib::Object';

sub new {
	my ($class, @args) = @_;
	$class->SUPER::new(@args);
}

sub init {
	1
}

sub new {
	my ($class, %args) = @_;
	my $self = bless {}, $class;

	$self{'name'} = $args{'NAME'} || 'World';

	return $self;
}

sub view {
	# the object itself will work for the view
	return shift;
}

1;