package Controller::Index;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Middleware::Authentication;
use Model::Question;
use POSIX; # per ceil

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
	my @lastQuestions = Model::Question::getLastQuestions($page);
	
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