package App::Mook::API::Note;

use Dancer2 appname => 'App::Mook::API';
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::REST;

prepare_serializer_for_format;

sub note_r {
  return resultset ( 'Note' )->find ( route_parameters->{id} );
}

sub user_id {
  return session->read ( 'user' ) // body_parameters->{user}; # FIXME fallback is a typical "bad good idea" for testing purposes
}

resource note =>
  create => sub {
    return status_created ( resultset ( 'Note' )->create ({
      title   => body_parameters->{title},
      content => body_parameters->{content},
      user_id => user_id (),
    })->as_h );
  },
  get    => sub {
    return status_ok ( note_r ()->as_h );
  },
  update => sub {
    note_r ()->update ({
      title   => body_parameters->{title},
      content => body_parameters->{content},
    });

    return status_reset_content ();
  },
  delete => sub {
    note_r ()->delete;

    return status_no_content ();
  };

get '/notes.:format' => sub {
  return status_ok ( [ map { $_->as_h } resultset ( 'Note' )->search (
    { user_id  => user_id () },
    { order_by => 'title' },
  ) ] );
};

true;
