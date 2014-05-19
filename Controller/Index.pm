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
	my $TestoDaCercare = $req->param("testoDaCercare") or "";
	my $page = $req->param("page") || 1;
	my $questionsPerPage = 3;
	my $data;


	if ($req->attr("method") eq 'POST' ) {

		my $totalQuestionsF = Model::Question::countQuestionsFind($TestoDaCercare); 

		if (($page - 1) * $questionsPerPage > $totalQuestionsF) {
			$page = ceil( $totalQuestionsF / $questionsPerPage );
		}
		my $totalPages = ceil( $totalQuestionsF / $questionsPerPage );
		my @lastQuestionsFind = Model::Question::getLastQuestionsFind($page,$TestoDaCercare);

		# Execution
		$data = {
			"logged" => Middleware::Authentication::isLogged($req),
			"questions" => \@lastQuestionsFind,
			"pageInfo" => {
				currentPageNumber => $page,
				totalPages => $totalPages
			}
		};
	}
	
	else {

		my $totalQuestions = Model::Question::countQuestions();
		if (($page - 1) * $questionsPerPage > $totalQuestions) {
			$page = ceil( $totalQuestions / $questionsPerPage );
		}
		my $totalPages = ceil( $totalQuestions / $questionsPerPage );
		my @lastQuestions = Model::Question::getLastQuestions($page);

		# Execution
		$data = {
			"logged" => Middleware::Authentication::isLogged($req),
			"questions" => \@lastQuestions,
			"pageInfo" => {
				currentPageNumber => $page,
				totalPages => $totalPages
			}
		};
	}

	# Response
	$res->write(Lib::Renderer::render('index.html', $data));
}

1;