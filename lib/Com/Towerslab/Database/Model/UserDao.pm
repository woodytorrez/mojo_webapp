package Com::Towerslab::Database::Model::UserDao;

use strict;
use warnings;
use POSIX;
use Com::Towerslab::Database::Data::User;

# ============================================================================================
#
# ============================================================================================
sub new {
    my $class = shift;
    my $dbh   = shift;

    my $self  = {
        _dbh => $dbh
    };

    bless $self, $class;

    return $self;
}

# ============================================================================================
#
# ============================================================================================
sub getUserByUsername {
    my $self      = shift;
    my $username  = shift;
    my $user      = undef;
    my $statement = $self->{_dbh}->prepare($self->selectClause().'WHERE T1.username = ?') or die 'Failed to prepare statement: '.$self->{_dbh}->errstr;
    my @users     = ();

    $statement->execute($username) or die 'Failed to execute statement: '.$statement->errstr;

    while (my $row = $statement->fetchrow_hashref)
    {
        $user = $self->createDataObject($row);
    }

    $statement->finish();

    return $user;
}

# ============================================================================================
#
# ============================================================================================
sub getAllUsers {
    my $self      = shift;
    my $statement = $self->{_dbh}->prepare($self->selectClause()) or die 'Failed to prepare statement: '.$self->{_dbh}->errstr;
    my @users     = ();

    $statement->execute() or die 'Failed to execute statement: '.$statement->errstr;

    while (my $row = $statement->fetchrow_hashref)
    {
        push(@users, $self->createDataObject($row));
    }

    $statement->finish();

    return \@users;
}

# ============================================================================================
#
# ============================================================================================
sub selectClause {
    my $self = shift;

    return qq{
        SELECT
            T1.id,
            T1.name,
            T1.username,
            T1.password,
            T1.title,
            T1.persona
        FROM
            user AS T1 
    };
}

# ============================================================================================
#
# ============================================================================================
sub createDataObject {
    my $self       = shift;
    my $row        = shift;
    my $dataObject = Com::Towerslab::Database::Data::User->new();

    $dataObject->id($row->{id});
    $dataObject->name($row->{name});
    $dataObject->username($row->{username});
    $dataObject->password($row->{password});
    $dataObject->title($row->{title});
    $dataObject->persona($row->{persona});

    return $dataObject;
}

1;
