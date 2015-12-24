package MooseX::Storage::Engine::IO::PgDocStore;

our $VERSION = '0.01';

use Moose;
use namespace::autoclean;

use Carp;

has 'dbh' => (
    is => 'ro',
    isa => 'DBI::db',
    required => 1,
);

has 'uuid' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

sub load {
    my ($self) = @_;

my $load_sql = <<EOF;
    SELECT json
    FROM json
    WHERE uuid=?
    LIMIT 1
EOF

    my $sth = $self->dbh->prepare($load_sql);
    my $rv = $sth->execute($self->uuid);
    if (!$rv) {
        croak "Error loading object ($self->uuid): $sth->err";
    }
    return $self->dbh->selectrow_array($sth);
}

sub store {
    my ($self, $json) = @_;

my $store_sql = <<EOF;
    INSERT INTO json (uuid, json)
        VALUES (?, ?)
EOF
my $update_sql = <<EOF;
    UPDATE json 
    SET json = ?
    WHERE uuid = ?
EOF

    my $sth = $self->dbh->prepare($store_sql);
    my $rv = $sth->execute($self->uuid, $json);
    if (!$rv) {
        $sth = $self->dbh->prepare($update_sql);
        $rv = $sth->execute($json, $self->uuid);
        if (!$rv) {
            croak "Failed to insert or update object ($self->uuid): $sth->err";
        }
    }
    return $rv;
}

1;
