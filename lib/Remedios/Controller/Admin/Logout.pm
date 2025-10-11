package Remedios::Controller::Admin::Logout;

use parent Remedios::Controller::BaseController;

# =============================================================================
# 
# =============================================================================
sub default {
    my $self = shift;

    delete $self->session->{loggedIn};
    delete $self->session->{userId};
    delete $self->session->{userPersona};
    
    return $self->redirectWithSuccessMessage('/', 'You have been logged out...');
}

1;
