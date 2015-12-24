# ABSTRACT: Store Moose objects in Postgres as JSON
package MooseX::Storage::IO::PgDocStore;

our $VERSION = '0.01';

use JSON;
use Moose::Role;
use MooseX::Storage::Engine::IO::PgDocStore;
use namespace::autoclean;

requires 'freeze';
requires 'thaw';
requires 'uuid';

sub load {
    my ($class, $dbh, $uuid, @args) = @_;
    my $json = MooseX::Storage::Engine::IO::PgDocStore->new( dbh => $dbh, uuid => $uuid)->load();
    my $hash = decode_json($json);
    return eval $hash->{__CLASS__}.'->thaw($json, @args)';
}

sub store {
    my ($self, $dbh, @args) = @_;
    MooseX::Storage::Engine::IO::PgDocStore->new( dbh => $dbh, uuid => $self->uuid )->store( $self->freeze );
}

no Moose::Role;

1;
