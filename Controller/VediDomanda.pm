package Controller::VediDomanda;
use strict;
use warnings;
use CGI::Carp;
use Encode;
use POSIX;

use Lib::Renderer;
use Lib::Markup;
# use Model::Question;
# use Model::Answer;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	# TODO ...

	# registro i parametri (E' possibile farlo con $req?)
	my %param = &query_string_variables;

	# recupero tutte le risposte
	# my @allAnswers = Model::Answer::getAnswersByQuestionId($param{"id"});
	my @allAnswers = (
		{ author => "Nome 1", content => "Risposta a caso 1" },
		{ author => "Nome 2", content => "Risposta a caso 2" },
		{ author => "Nome 3", content => "Risposta a caso 3" },
		{ author => "Nome 4", content => "Risposta a caso 4" },
		{ author => "Nome 5", content => "Risposta a caso 5" },
		{ author => "Nome 6", content => "Risposta a caso 6" },
		{ author => "Nome 7", content => "Risposta a caso 7" },
		{ author => "Nome 8", content => "Risposta a caso 8" },
		{ author => "Nome 9", content => "Risposta a caso 9" },
		{ author => "Nome 10", content => "Risposta a caso 10" }
	);

	if (!@allAnswers) {
		print CGI::redirect(-uri=>'page-error.cgi');
	}

	# prendo le risposte per la pagina $param{"page"}
	my $answersPerPage = 3;
	my $page = $param{"page"} || 1;
	my $arrSize = @allAnswers;
	if (($page - 1) * $answersPerPage > $arrSize) {
		$page = ceil( $arrSize / $answersPerPage );
	}
	my @answers = splice(@allAnswers, ($page - 1) * $answersPerPage, $answersPerPage);
	
	# Execution
	my $data = {
		"logged" => Middleware::Authentication::isLogged($req),
		# "question" => Model::Question::getQuestionById($param{"id"}),
		"question" => {
			"id" => 111,
			"author" => "Giuseppe",
			"title" => "Titolo domanda?",
			"content" => Lib::Markup::convert("Testo della domanda con **alcune parole** in grassetto.")
		},
		"answers" => \@answers,
		"pageInfo" => {
			currentPageNumber => $page,
			totalPages => ceil( $arrSize / $answersPerPage )
		}
	};
	
	# Response
	$res->write(Lib::Renderer::render('vedi-domanda.html', $data));
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