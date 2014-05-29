package Controller::VediDomanda;
use strict;
use warnings;
use CGI::Carp;
use Encode;
use POSIX;

use Lib::Renderer;
use Lib::Markup;
use Lib::Utils;
use Middleware::Session;
use Model::Question;
use Model::Answer;

sub handler {
	# Get parameters
	my ($req, $res) = @_;
	my @allAnswers;
	
	# TODO ...

	if ($req->attr("method") eq 'POST') {

		# controllo se è una richiesta di cambio di stato della domanda
		if ($req->param("status")) {

			my $question = Model::Question::getQuestionById($req->param("questionId"));
			my $sessionMail = Middleware::Session::getSession($req)->param('email');

			# se l'utente è l'autore della domanda
			if ($question->{author} == $sessionMail) {
				if ($req->param("status") == 'opened') {
					Model::Question::setQuestionAsOpened($req->param("questionId"));
				}
				elsif ($req->param("status") == 'solved') {
					Model::Question::setQuestionAsSolved($req->param("questionId"));
				}
			}
		}
		# controllo se il campo di inserimento della risposta non è vuoto
		elsif ($req->param("post-text")) {

			my $text = $req->param("post-text");

			# controllo che non si stia tentando di inserire una risposta ad una domanda chiusa
			if (Model::Question::getQuestionById($req->param("questionId"))->{status} == 'opened') {
				my $author = Middleware::Session::getSession($req)->param('email');
				Model::Answer::insertAnswer($req->param("questionId"), $text, $author);
			}
		}

		# recupero tutte le risposte
		@allAnswers = Model::Answer::getAnswersByQuestionId($req->param('questionId'));
	} else {
		# recupero tutte le risposte
		@allAnswers = Model::Answer::getAnswersByQuestionId($req->param('id'));
	}

	# TODO: ho commentato perche se la domanda non ha risposte reindirizza a page-error!
	# if (!@allAnswers) { 
	# 	return $res->redirect("page-error.cgi");
	# }

	# prendo le risposte per la pagina $req->param("page")
	my $answersPerPage = 9;
	my $page;
	if ($req->param("page") > 0) {
		$page = $req->param("page");
	} else {
		$page = 1;
	}
	my $arrSize = @allAnswers;
	if (($page - 1) * $answersPerPage > $arrSize) {
		$page = ceil( $arrSize / $answersPerPage );
	}
	my @answers = splice(@allAnswers, ($page - 1) * $answersPerPage, $answersPerPage);

	my $idDomanda;
	if ($req->attr("method") eq 'POST') {
		$idDomanda = $req->param('questionId');
	} else {
		$idDomanda = $req->param("id");
	}

	# Execution
	my $data = {
		"logged" => Middleware::Authentication::isLogged($req),
		"session" => {
			"email" => Middleware::Session::getSession($req)->param("email")
		},
		"question" => Model::Question::getQuestionById($idDomanda),
		"answers" => \@answers,
		"totalAnswers" => $arrSize,
		"pageInfo" => {
			currentPageNumber => $page,
			totalPages => ceil( $arrSize / $answersPerPage )
		}
	};
	
	# Response
	$res->write(Lib::Renderer::render('vedi-domanda.html', $data));
}

1;