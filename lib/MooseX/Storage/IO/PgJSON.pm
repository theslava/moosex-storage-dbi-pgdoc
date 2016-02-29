# ABSTRACT: Store Moose objects in Postgres as JSON
package MooseX::Storage::IO::PgJSON;

our $VERSION = '0.01';

use Carp;
use JSON;
use Moose::Role;
use MooseX::Storage::Engine::IO::PgJSON;
use namespace::autoclean;

requires 'freeze';
requires 'thaw';

sub load {
    my ($class, $dbh, $filter, @args) = @_;
    return $class->thaw(
        MooseX::Storage::Engine::IO::PgJSON->new( dbh => $dbh )->load( $filter ),
        @args,
    );
}

sub store {
    my ($self, $dbh) = @_;
    MooseX::Storage::Engine::IO::PgJSON->new( dbh => $dbh )->store( $self->freeze );
}

no Moose::Role;

1;
