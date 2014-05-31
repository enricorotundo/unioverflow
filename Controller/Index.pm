package Controller::Index;
use strict;
use warnings;
use CGI::Carp;

use Lib::Renderer;
use Middleware::Authentication;
use Model::Question;
use POSIX; # per ceil
use Lib::Sanitize; # Per filtrare gli input
use Lib::Utils;

sub handler {

	# Get parameters
	my ($req, $res) = @_;
	my $TestoDaCercareOriginale = $req->param("testoDaCercare");
	my $TestoDaCercareSano = Lib::Sanitize::search_query($TestoDaCercareOriginale) or "";
	# Evita XSS attack
	my $page = Lib::Sanitize::number($req->param("page"));
	if ($page eq "" or $page == 0) {
		$page = 1;
	}
	my $questionsPerPage = 9;
	my $data;
	my $error;

	# Se è stata effettuata una ricerca e non è una ricerca vuota (se cerco " " mi aspetto tutte le domande)
	if ($req->attr("method") eq 'GET' && !(Lib::Utils::trim($TestoDaCercareSano) eq '')) { 

		my $totalQuestionsF = Model::Question::countQuestionsFind($TestoDaCercareSano); 

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
			my @lastQuestionsFind = Model::Question::getLastQuestionsFind($page, $questionsPerPage, $TestoDaCercareSano);


			if($TestoDaCercareOriginale ne $TestoDaCercareSano){
				# creo il msg di errore
				my $msg = "I caratteri &quot; &#39; sono stati ignorati.";

				# Execution
				$data = {
					"logged" => Middleware::Authentication::isLogged($req),
					"questions" => \@lastQuestionsFind,
					"pageInfo" => {
						currentPageNumber => $page,
						totalPages => $totalPages
					},
					"error" => 1,
					"msg" => $msg
				};
			}
			else {

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

1;