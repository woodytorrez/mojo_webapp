package Remedios::Controller::Login;

use parent Remedios::Controller::BaseController;
use Com::Towerslab::Database::Model::UserDao;

# =============================================================================
# 
# =============================================================================
sub admin {
    my $self     = shift;
    my $username = $self->param('username');
    my $password = $self->param('password');

    my $dbh      = $self->DatabaseConnection;
    my $userDao  = Com::Towerslab::Database::Model::UserDao->new($dbh);
    my $user     = $userDao->getUserByUsername($username);

    if ($user && $user->passwordMatches($password)) {
        $self->session(isLoggedIn  => 1);
        $self->session(userId      => $user->id());
        $self->session(userPersona => $user->persona());
        $dbh->disconnect();

        return $self->redirectWithSuccessMessage('/admin', 'Welcome...');
    }
    else {
        $self->flash(username => $username);
        $self->flash(password => $password);
        $dbh->disconnect();

        return $self->redirectWithErrorMessage('/', 'Invalid username/password...');
    }
}

1;
