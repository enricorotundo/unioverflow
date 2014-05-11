package Controller::VediDomanda;
use strict;
use warnings;
use CGI::Carp;
use Encode;
use POSIX;

use Lib::Renderer;
use Lib::Markup;
use Model::Question;
# use Model::Answer;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	# TODO ...

	# recupero tutte le risposte
	# my @allAnswers = Model::Answer::getAnswersByQuestionId($req->param("id"));
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
		return $res->redirect("page-error.cgi");
	}

	# prendo le risposte per la pagina $req->param("page")
	my $answersPerPage = 3;
	my $page = $req->param("page") || 1;
	my $arrSize = @allAnswers;
	if (($page - 1) * $answersPerPage > $arrSize) {
		$page = ceil( $arrSize / $answersPerPage );
	}
	my @answers = splice(@allAnswers, ($page - 1) * $answersPerPage, $answersPerPage);
	
	# Execution
	my $data = {
		"logged" => Middleware::Authentication::isLogged($req),
		"question" => Model::Question::getQuestionById($req->param("id")),
		"answers" => \@answers,
		"pageInfo" => {
			currentPageNumber => $page,
			totalPages => ceil( $arrSize / $answersPerPage )
		}
	};
	
	# Response
	$res->write(Lib::Renderer::render('vedi-domanda.html', $data));
}

1;