package Lib::Route;
use strict;
use warnings;
use diagnostics;
use CGI::Carp;
use Lib::Response;

sub handler {
	my ($request) = @_;

	# TODO: choose controller

	use Controller::Index;
	my $response = Controller::Index::handler($request);

	return $response;
}

1;