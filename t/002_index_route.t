use strict;
use warnings;

use App::Mook;
use Test::More;
use Plack::Test;
use HTTP::Cookies;
use HTTP::Request::Common;

plan tests => 8;

my $app = App::Mook->get_app;
is ( ref $app, 'CODE', 'Got app' );

my $jar  = HTTP::Cookies->new;
my $test = Plack::Test->create ( $app );

{
  my $response = $test->request ( GET '/' );
  my $headers  = $response->headers;

  ok ( $response->is_redirect, '[GET /] redirected' );
  like ( $response->as_string, qr| \b http://localhost/login \b |x, '[GET /] redirect URL' );

  is ( $headers->header ( 'x-content-type-options' ), undef, '[GET /] no X-Content-Type-Options header' ); # nosniff
  is ( $headers->header ( 'x-frame-options'        ), undef, '[GET /] no X-Frame-Options header'        ); # DENY
  is ( $headers->header ( 'x-xss-protection'       ), undef, '[GET /] no X-XSS-Protection header'       ); # 1; mode=block
  
  $jar->extract_cookies ( $response );
  my $cookies = $jar->as_string;
  ok ( $cookies, '[GET /] cookies' );
  unlike ( $cookies, qr/ \b HttpOnly \b /x, '[GET /] no HttpOnly cookie' );
}
