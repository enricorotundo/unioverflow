package Controller::PageError;
use strict;
use warnings;
use CGI::Carp;
use Lib::Renderer;

# Se serve, mettere qua gli altri moduli richiesti
# use ...

sub handler {
    # Get parameters
    my ($req, $res) = @_;

    # Mettere qua il codice del controller
    # ...

    # Costruire il dizionario con i dati da passare al template
    my $data = {
        "error" => "Messaggio di errore"

    };

    # Visualizza il template
    $res->write(Lib::Renderer::render('page-error.html', $data));
}

1;