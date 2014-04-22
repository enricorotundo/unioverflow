package Controller::Index;
use strict;
use warnings;
use CGI::Carp;
use Encode;

use Lib::Renderer;
use Middleware::Authentication;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	my %param = &query_string_variables;
	
	# TODO : calcolare le pagine totali e settare il valore a $data.pageInfo.totalPages
	
	# Execution
	my $data = {
		"logged" => Middleware::Authentication::isLogged($req),
		"questions" => [
			{ path => "vedi-domanda.cgi?id=123", title => "Non so fare niente.", author => "Gianni" },
			{ path => "vedi-domanda.cgi?id=124", title => "Sono il più scarso?", author => "Beppe" },
			{ path => "vedi-domanda.cgi?id=125", title => "\"Beauty for reality\" cit.", author => "Serena" },
		],
		"pageInfo" => {
			currentPageNumber => $param{"page"},
			totalPages => 8
		}
	};

	# Response
	$res->write(Lib::Renderer::render('index.html', $data));
}


# Fetches and parses query-string variables.
# Returns an associative array like $param{$key} = $value.
sub query_string_variables {

	my $query_string = '';
	if ($ENV{'REQUEST_METHOD'}) {
		$query_string = $ENV{'QUERY_STRING'};
	}

	my %param;
	my @pairs = split(/[&;]/, $query_string);

	foreach (@pairs) {
		my($key, $value) = split(/=/, $_, 2);

		next if !defined $key;

		$key =~ tr/+/ /;
		$key =~ s/%([0-9a-fA-F]{2})/chr(hex($1))/ge;
		$key = Encode::decode_utf8($key);

		next if ($key eq '');

		if (defined $value) {
			$value =~ tr/+/ /;
			$value =~ s/%([0-9a-fA-F]{2})/chr(hex($1))/ge;
			$value = Encode::decode_utf8($value);
		}

		$param{$key} = $value;
	}
	return %param;
}

1;