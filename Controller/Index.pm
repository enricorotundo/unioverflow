package Controller::Index;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Middleware::Authentication;
# use Model::Question;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	# TODO ...

	my $page = $req->param("page") || 1;
	my $questionsPerPage = 3;
	# my $totalQuestions = Model::Question::countQuestions();
	my $totalQuestions = 5;
	if (($page - 1) * $questionsPerPage > $totalQuestions) {
		$page = ceil( $totalQuestions / $questionsPerPage );
	}
	my $totalPages = ceil( $totalQuestions / $questionsPerPage );
	# my @lastQuestions = Model::Question::getLastQuestions($page);
	my @lastQuestions = (
		{ path => "vedi-domanda.cgi?id=123", title => "Non so fare niente.", author => "Gianni" },
		{ path => "vedi-domanda.cgi?id=124", title => "Sono il più scarso?", author => "Beppe" },
		{ path => "vedi-domanda.cgi?id=125", title => "\"Beauty for reality\" cit.", author => "Serena" },
	);
	
	# Execution
	my $data = {
		"logged" => Middleware::Authentication::isLogged($req),
		"questions" => \@lastQuestions,
		"pageInfo" => {
			currentPageNumber => $page,
			totalPages => $totalPages
		}
	};

	# Response
	$res->write(Lib::Renderer::render('index.html', $data));
}

1;