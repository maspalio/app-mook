use strict;
use warnings;

use App::Mook::NOT;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use Cpanel::JSON::XS;

plan tests => 5;

my $app = App::Mook::NOT->get_app;
is ( ref $app, 'CODE', 'Got app' );

my $test = Plack::Test->create ( $app );

{
  my $id       = 1;
  my $response = $test->request ( GET "/note/$id.json" );
  my $content  = decode_json ( $response->content );
  
  is ( $content->{title},   'Margarita', '[GET (/not)/note/1.json] title' );
  is ( $content->{user_id}, 'jdoe',      '[GET (/not)/note/1.json] user_id' );
}

{
  my $id       = "1' OR 1 ORDER BY id DESC; --";
  my $response = $test->request ( GET "/note/$id.json" );
  my $content  = decode_json ( $response->content );
  
  is ( $content->{title},   "Dark 'n' Stormy", '[GET (/not)/note/1.json] title' );
  is ( $content->{user_id}, 'jdoe',            '[GET (/not)/note/1.json] user_id' );
}
