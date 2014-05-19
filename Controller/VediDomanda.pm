package Controller::VediDomanda;
use strict;
use warnings;
use CGI::Carp;
use Encode;
use POSIX;

use Lib::Renderer;
use Lib::Markup;
use Middleware::Session;
use Model::Question;
use Model::Answer;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	
	# TODO ...

	# recupero tutte le risposte
	my @allAnswers = Model::Answer::getAnswersByQuestionId($req->param("id"));

	# TODO: ho commentato perche se la domanda non ha risposte reindirizza a page-error!
	# if (!@allAnswers) { 
	# 	return $res->redirect("page-error.cgi");
	# }

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
		"session" => {
			"email" => Middleware::Session::getSession($req)->param("email")
		},
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