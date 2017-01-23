use strict;
use warnings;

use App::Mook;
use Test::More;
use Test::WWW::Mechanize::PSGI;

plan tests => 8;

my $mech = Test::WWW::Mechanize::PSGI->new ( app => App::Mook->get_app );

$mech->get_ok ( '/', '[GET /]' );
is ( $mech->res->base, 'http://localhost/login', '[GET /] /login URL' );
$mech->submit_form_ok ( { fields => { id => 'jdoe', pass => 'correcthorsebatterystaple' } }, '[POST /login]' );
ok ( my $cookie1 = rip_cookie ( $mech ), '[GET /] session cookie' );

$mech->get_ok ( '/', '[GET /]' );
is ( $mech->res->base, 'http://localhost/', '[GET /] URL' );
ok ( my $cookie2 = rip_cookie ( $mech ), '[GET /] session cookie' );
ok ( $cookie1 eq $cookie2, "[GET /] same session cookie == $cookie1" );

sub rip_cookie {
  my ( $mech ) = @_;
  
  $mech->cookie_jar->as_string =~ / \b dancer\.session = (?<cookie> [^;]+ ) ; /x;
  
  return $+{cookie};
}
