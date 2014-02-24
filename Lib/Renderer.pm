package Lib::Renderer;
use strict;
use warnings;
use CGI::Carp;
use Template;
use Lib::Config;
use Lib::Response;

sub render {
	my ($templateFile, $data, $response) = @_;
	$response ||= Lib::Response->new();

	my $content = render_template($templateFile, $data);
	$response->set_content($content);
	
	return $response;
}

sub render_template {
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