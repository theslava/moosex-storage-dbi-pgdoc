package MooseX::Storage::Engine::IO::PgJSON;

our $VERSION = '0.01';

use Moose;
use namespace::autoclean;

use Carp;

has 'dbh' => (
    is => 'ro',
    isa => 'DBI::db',
    required => 1,
);

has 'load_sql' => (
    is => 'ro',
    isa => 'Str',
    default => 'SELECT data FROM data WHERE data @> ? LIMIT 1',
);

has 'store_sql' => (
    is => 'ro',
    isa => 'Str',
    default => 'INSERT INTO data (data) VALUES (?) ON CONFLICT (uuid) DO UPDATE SET data = EXCLUDED.data',
);

sub load {
    my ($self, $filter) = @_;

    my $sth = $self->dbh->prepare($self->load_sql);
    my $rv = $sth->execute( $filter );
    if (!$rv) {
        croak "Error loading object ($filter): $sth->err";
    }
    return $self->dbh->selectrow_array($sth);
}

sub store {
    my ($self, $object) = @_;

    my $sth = $self->dbh->prepare($self->store_sql);
    my $rv = $sth->execute($object);
    if (!$rv) {
        croak "Failed to insert or update object ($object): $sth->err";
    }
    return $rv;
}

1;
