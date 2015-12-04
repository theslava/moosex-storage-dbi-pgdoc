# ABSTRACT: Store Moose objects in Postgres as JSON
package MooseX::Storage::IO::PgDocStore;

our $VERSION = '0.01';

use Moose::Role;
use MooseX::Storage::Engine::IO::PgDocStore;
use namespace::autoclean;

requires 'freeze';
requires 'thaw';
requires 'uuid';

sub load {
    my ($class, $dbh, $uuid, @args) = @_;
    $class->thaw( MooseX::Storage::Engine::IO::PgDocStore->new( dbh => $dbh, uuid => $uuid)->load(), @args);
}

sub store {
    my ($self, $dbh, @args) = @_;
    MooseX::Storage::Engine::IO::PgDocStore->new( dbh => $dbh, uuid => $self->uuid )->store( $self->freeze );
}

no Moose::Role;

1;
