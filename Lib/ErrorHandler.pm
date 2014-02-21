package Lib::ErrorHandler;
use strict;
use warnings;
use diagnostics;

use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

# Redefine error_handler
#use CGI::Carp qw(set_die_handler);

# Redefine message_handler
use CGI::Carp qw(set_message);
use Template;
use Lib::Config;

BEGIN {
	sub print_stack_trace 
	{
		my $message = shift;

		my $data = {};
		$data->{"message"} = $message;
		$data->{"trace"} = [];

		use Devel::StackTrace;
		use Data::Dumper 'Dumper';
		
		my $trace = Devel::StackTrace->new();
		while( my $frame = $trace->next_frame() ) {
			push ($data->{"trace"}, {
				"subroutine" => $frame->subroutine,
				"dump" => Dumper(+($frame->args)),
				"args" => $frame->args,
				"file" => $frame->filename,
				"line" => $frame->line
			});
		}

		my $template = Template->new({
			INCLUDE_PATH => $Lib::Config::templatePath
		});
		
		return $template->process("error.html", $data) || $template->error();
	}

	set_message(\&print_stack_trace);
}

1;

