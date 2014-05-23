package Model::dbFiller;
use strict;
use warnings;
use CGI::Carp;

use Model::User;
use Model::Question;
use Model::Answer;

sub dbFiller {

	my @users = Model::User->getUsers();

	foreach my $user (@users) {
		my $author = $user->{'email'};
		my $title = 'title';
		my $content = 'content';

		Model::Question->insertQuestion($content, $author);
	}
}

1;