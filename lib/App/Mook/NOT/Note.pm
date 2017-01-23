package App::Mook::NOT::Note;

use Dancer2 appname => 'App::Mook::NOT';
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::REST;

prepare_serializer_for_format;

resource note =>
  get => sub {
    return status_ok ( schema->storage->dbh_do ( sub {
      my ( $storage, $dbh ) = @_;

      my $query = "SELECT * FROM note WHERE id = '@{[ route_parameters->{id} ]}';"; # FIXME should be: my $query = "SELECT * FROM note WHERE id = ?;";
      return $dbh->selectrow_hashref ( $query );                                    # FIXME should be: return $dbh->selectrow_hashref ( $query, undef, route_parameters->{id} );
    } ) );
  };

true;
