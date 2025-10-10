package Remedios::Controller::Admin::Logout;

use parent Remedios::Controller::BaseController;

# =============================================================================
# 
# =============================================================================
sub default {
    my $self = shift;

    delete $self->session->{isLoggedIn};
    delete $self->session->{userId};
    delete $self->session->{userPersona};

    return $self->redirectWithSuccessMessage('/', 'You have been logged out...');
}

1;
