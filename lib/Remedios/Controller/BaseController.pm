package Remedios::Controller::BaseController;

use Mojo::Base 'Mojolicious::Controller';

# =============================================================================
# 
# =============================================================================
sub redirectWithSuccessMessage {
    my ($self, $location, $message) = @_;

    $self->flash(message     => $message);
    $self->flash(messageType => 'success');
    $self->redirect_to($location);

    return undef;
}

# =============================================================================
# 
# =============================================================================
sub redirectWithErrorMessage {
    my ($self, $location, $message) = @_;

    $self->flash(message     => $message);
    $self->flash(messageType => 'danger');
    $self->redirect_to($location);
    
    return undef;
}

1;
