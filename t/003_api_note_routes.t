use strict;
use warnings;

use App::Mook::API;
use Test::More;
use Plack::Test;
use HTTP::Request::Common qw( GET POST );
use Cpanel::JSON::XS;

plan tests => 5;

my $app = App::Mook::API->get_app;
is ( ref $app, 'CODE', 'Got app' );

my $test = Plack::Test->create ( $app );

{
  my $response = $test->request ( GET '/note/1.json' );
  my $content  = decode_json ( $response->content );
  
  is ( $content->{title},   'Margarita', '[GET (/api)/note/1.json] title' );
  is ( $content->{user_id}, 'jdoe',      '[GET (/api)/note/1.json] user_id' );
}

{
  my $response = $test->request ( post_http_request ( '/note.json' => {
    user    => 'jdoe',
    title   => "Dark 'n' Stormy",
    content => "1 part Gosling's Black Seal rum\n2 parts ginger beer\n\nFill glass with ice, add, rum, then top with ginger beer. Squeeze in, then garnish with a lime wedge.",
  } ) );

  is ( $response->status_line, '201 Created', '[POST (/api)/note.json] status line' );
}

{
  my $response = $test->request ( GET '/notes.json' );
  my $content  = decode_json ( $response->content );
  
  is_deeply ( [ map { $_->{title} } @$content ], [], '[GET (/api)/notes.json] titles' );
}

sub post_http_request {
  my ( $url, $content ) = @_;

  my $json = encode_json ( $content );

  my $request = HTTP::Request->new ( POST => $url );
  $request->header  ( 'Content-Type' => 'application/json', 'Content-Length' => length $json );
  $request->content ( $json );

  return $request;
}
