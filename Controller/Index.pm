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
	my $page;
	if ($req->param("page") > 0) {
		$page = $req->param("page");
	} else {
		$page = 1;
	}
	my $questionsPerPage = 3;
	my $data;

	# Se è stata effettuata una ricerca e non è una ricerca vuota (se cerco " " mi aspetto tutte le domande)
	if ($req->attr("method") eq 'POST' && !(trim($TestoDaCercare) eq '')) { 

		my $totalQuestionsF = Model::Question::countQuestionsFind($TestoDaCercare); 

		if ($totalQuestionsF == 0) {
			$data = {
			"logged" => Middleware::Authentication::isLogged($req),
			"notFound" => 1,
			"pageInfo" => {
					currentPageNumber => 1,
					totalPages => 1
				}
			};
		}
		else {

			if (($page - 1) * $questionsPerPage > $totalQuestionsF) {
				$page = ceil( $totalQuestionsF / $questionsPerPage );
			}
			my $totalPages = ceil( $totalQuestionsF / $questionsPerPage );
			my @lastQuestionsFind = Model::Question::getLastQuestionsFind($page, $questionsPerPage, $TestoDaCercare);

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
	}
	
	else {

		my $totalQuestions = Model::Question::countQuestions();
		if (($page - 1) * $questionsPerPage > $totalQuestions) {
			$page = ceil( $totalQuestions / $questionsPerPage );
		}
		my $totalPages = ceil( $totalQuestions / $questionsPerPage );
		my @lastQuestions = Model::Question::getLastQuestions($page, $questionsPerPage);

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

# Restituisce la stringa senza spazi
sub trim($)
{
	my $string = shift;
	$string =~ s/\s+//g;
	return $string;
}

1;