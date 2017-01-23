package App::Mook;

our $VERSION = '0.1';

use Dancer2;
use Dancer2::Plugin::DBIC;
use DBIx::Class::ResultClass::HashRefInflator;
use Plack::Builder;
use Plack::Middleware::Headers;

use App::Mook::API::Note;
use App::Mook::Login;
use App::Mook::Logout;
use App::Mook::NOT::Note;

get '/' => sub {
  if ( my $id = session->read ( 'user' ) ) {
    my @notes;

    if ( my $r = resultset ( 'User' )->find ( $id ) ) {
      if ( my $rs = $r->notes ( {}, { order_by => 'title' } ) ) {
        $rs->result_class ( 'DBIx::Class::ResultClass::HashRefInflator' );
        @notes = $rs->all;
      }
    }

    template 'index', {
      notes   => \@notes,
      title   => query_parameters->{title},
      content => query_parameters->{content},
    };
  }
  else {
    redirect ( '/login' );
  }
};

sub get_app {
  return builder {
    enable 'Headers' => (
      # set => [
      #   'X-Content-Type-Options' => 'nosniff',
      #   'X-Frame-Options'        => 'DENY',
      #   'X-XSS-Protection'       => '1; mode=block',
      # ],
      unset => [
        'Server'
      ],
    );

    App::Mook->to_app;
  };
}

true;
