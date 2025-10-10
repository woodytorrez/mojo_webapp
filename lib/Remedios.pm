package Remedios;

use Mojo::Base 'Mojolicious';
use DBI;

sub startup {
    my $self = shift;

    $self->defaults(
        title  => '__TITLE__',
        layout => 'default'
    );

    $self->setupConfig();
    $self->setupHelpers();
    $self->setupRoutes();
}

# =============================================================================
# 
# =============================================================================
sub setupConfig {
    my $self = shift;

    $self->plugin('NotYAMLConfig');
    $self->secrets($self->config->{secrets});
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

    $self->helper(isLoggedIn => sub {
        my $self = shift;

        return defined($self->session->{isLoggedIn}) && $self->session->{isLoggedIn} == 1 && defined($self->session->{userId}) && $self->session->{userId} > 0;
    });

    $self->helper(CanAccess => sub {
        my $self = shift;

        return $self->isLoggedIn && $self->req->url =~ m/^\/admin/;
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

        return 1;
#        return 1 if $self->CanAccess;

#        $self->flash(message     => 'Cannot access...');
#        $self->flash(messageType => 'error');
#        $self->redirect_to('/');

#        return undef;
    });

    $admin->get('/')      ->to(controller => 'Admin::Home',   action => 'default', layout => 'admin');
    $admin->get('/logout')->to(controller => 'Admin::Logout', action => 'default');
}

1;
