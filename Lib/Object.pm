package Lib::Object;
use strict;
use warnings;
use diagnostics;
use CGI::Carp;

# constructor
sub new {
	my ($class, %args) = @_;
	my $self = \%args;
	bless $self, $class;
	$self->init(%args);
	return $self;
}

# initializer
sub init {1}

1;