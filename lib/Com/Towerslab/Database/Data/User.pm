package Com::Towerslab::Database::Data::User;

use strict;
use warnings;
use POSIX;
use Digest::MD5     qw(md5_hex);

sub new {
    my $class = shift;
    my $self  = {
        _id            => undef,
        _name          => undef,
        _username      => undef,
        _password      => undef,
        _title         => undef,
        _persona       => undef,
        _date_created  => undef,
        _date_modified => undef,
        _created_by    => undef,
    };

    bless $self, $class;

    return $self;
}

sub id {
    my $self     = shift;
    $self->{_id} = shift if (scalar(@_) == 1);

    return $self->{_id};
}

sub name {
    my $self       = shift;
    $self->{_name} = shift if (scalar(@_) == 1);

    return $self->{_name};
}

sub username {
    my $self           = shift;
    $self->{_username} = shift if (scalar(@_) == 1);

    return $self->{_username};
}

sub password {
    my $self           = shift;
    $self->{_password} = shift if (scalar(@_) == 1);

    return $self->{_password};
}

sub passwordMatches {
    my $self          = shift;
    my $givenPassword = shift;

    return $self->{_password} eq md5_hex($givenPassword);
}

sub title {
    my $self        = shift;
    $self->{_title} = shift if (scalar(@_) == 1);

    return $self->{_title};
}

sub persona {
    my $self          = shift;
    $self->{_persona} = shift if (scalar(@_) == 1);

    return $self->{_persona};
}

1;
