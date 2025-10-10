package Remedios::Controller::Home;

use parent Remedios::Controller::BaseController;

# =============================================================================
# 
# =============================================================================
sub default {
    my $self = shift;

    $self->render();
}

1;
