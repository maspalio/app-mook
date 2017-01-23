package App::Mook::Login;

use Dancer2 appname => 'App::Mook';
use Dancer2::Plugin::DBIC;
use Digest::MD5 qw( md5_hex );

get '/login' => sub {
  template 'login';
};
 
post '/login' => sub {
  my $id   = body_parameters->get ( 'id' );
  my $pass = body_parameters->get ( 'pass' );

  if ( authenticated ( $id, $pass ) ) {
    session user => $id;

    return redirect '/';
  }
  else {
    template 'login' => { error => 'Invalid id or pass!' };
  }
};

sub authenticated {
  my ( $id, $pass ) = @_;

  if ( my $r = resultset ( 'User' )->find ( $id ) ) {
    return md5_hex ( $pass ) eq $r->pass;
  }

  return 0;
}

true;
