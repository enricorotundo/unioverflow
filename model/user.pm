package Model::User;
use strict;
use warning;
use diagnostics;
use Lib::Unioverflow;

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
