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
	sub print_stack_trace {
		my $message = shift;

		my $data = {};
		$data->{"message"} = $message;
		$data->{"trace"} = [];

		my $i = 1;

		while ( (my @call_details = (caller($i++))) ){
			push (@{ $data->{"trace"} }, {
				"package" => $call_details[0],
				"file" => $call_details[1],
				"line" => $call_details[2],
				"subroutine" => $call_details[3]
			});
		}

		#use Data::Dumper 'Dumper';
		#use Devel::StackTrace;
		#my $trace = Devel::StackTrace->new();
		#while( my $frame = $trace->next_frame() ) {
		#	push ($data->{"trace"}, {
		#		"subroutine" => $frame->subroutine,
		#		"dump" => Dumper(+($frame->args)),
		#		"args" => $frame->args,
		#		"file" => $frame->filename,
		#		"line" => $frame->line
		#	});
		#}

		my $template = Template->new({
			INCLUDE_PATH => $Lib::Config::templatePath
		});

		if ($template) {
			$template->process("error.html", $data) || print $template->error();
		} else {
			print "<html><body>";
			print "<h1>Error</h1>";
			print "<pre>".$data->{"message"}."</pre>";
			print "<h2>Stacktrace</h2>";
			print "<pre>";
			foreach my $call (@{ $data->{"trace"} }) {
				foreach my $key (sort keys %{ $call }) {
					print $key.": ".$call->{$key}."\n";
				}
				print "\n";
			}
			print "</pre>";
			print "</body></html>";
		}
	}

	set_message(\&print_stack_trace);
}

1;

