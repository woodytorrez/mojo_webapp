package Remedios;

use Mojo::Base 'Mojolicious';
use DBI;

sub startup {
    my $self = shift;

    $self->setupConfig();
    $self->setupHelpers();
    $self->setupRoutes();
}

# =============================================================================
# 
# =============================================================================
sub setupConfig {
    my $self = shift;

    # 86400 seconds = 24 hours
    $self->plugin('NotYAMLConfig');
    $self->secrets($self->config->{secrets});
    $self->sessions->default_expiration(86400);
    $self->defaults(
        title  => $self->config->{title},
        layout => 'default'
    );

}

# =============================================================================
# 
# =============================================================================
sub setupHelpers {
    my $self = shift;

    $self->helper(DatabaseConnection => sub {
        my $self = shift;
        my $dbh  = DBI->connect(
            'DBI:MariaDB:database='.$self->config->{database}->{name}.';host='.$self->config->{database}->{host},
            $self->config->{database}->{username},
            $self->config->{database}->{password},
            { PrintError => 0, RaiseError => 1 }
        );

        die "Failed to connect to MySQL database:DBI->errstr()" unless($dbh);

        return $dbh;
    });

    $self->helper(IsLoggedIn => sub {
        my $self = shift;

        return defined($self->session->{loggedIn}) && $self->session->{loggedIn} == 1 && defined($self->session->{userId}) && $self->session->{userId} > 0;
    });

    $self->helper(CanAccessPage => sub {
        my $self = shift;

        return    ($self->req->url =~ m/^\/admin/ && $self->IsLoggedIn && $self->session->{userPersona} eq 'admin')
               || ($self->req->url =~ m/^\/user/  && $self->IsLoggedIn && $self->session->{userPersona} eq 'user');
    });
}

# =============================================================================
# 
# =============================================================================
sub setupRoutes {
    my $self = shift;
    my $r    = $self->routes;

    $r->get('/')            ->to(controller => 'Home',  action => 'default');
    $r->post('/login/admin')->to(controller => 'Login', action => 'admin');

    # -------------------------------------------------------------------------
    # ADMIN URL's
    # -------------------------------------------------------------------------
    my $admin = $r->under('/admin' => sub {
        my $self = shift;

        return 1 if $self->CanAccessPage;

        $self->flash(message     => 'Sorry, you cannot access...');
        $self->flash(messageType => 'danger');
        $self->redirect_to('/');

        return undef;
    });

    $admin->get('/')      ->to(controller => 'Admin::Home',   action => 'default', layout => 'admin');
    $admin->get('/logout')->to(controller => 'Admin::Logout', action => 'default');
}

1;
