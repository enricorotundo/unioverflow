package Lib::Renderer;
use strict;
use warnings;
use CGI::Carp;

use Template;
use Lib::Config;

sub render {
	my ($templateFile, $data) = @_;
	
	my $template = Template->new({
		INCLUDE_PATH => $Lib::Config::templatePath,
		#PRE_PROCESS  => 'config',
	});
	
	my $content = "";
	$template->process($templateFile, $data, \$content) or die $template->error;
	
	return $content;
}

1;