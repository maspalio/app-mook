use strict;
use warnings;

use App::Mook;
use Test::More;
use Test::WWW::Mechanize::PSGI;

plan tests => 5;

my $mech = Test::WWW::Mechanize::PSGI->new ( app => App::Mook->get_app );

$mech->get_ok ( '/', '[GET /]' );
is ( $mech->res->base, 'http://localhost/login', '[GET /] /login URL' );
$mech->submit_form_ok ( { fields => { id => 'jdoe', pass => 'correcthorsebatterystaple' } }, '[POST /login] OK' );

my $payload = '<script>alert("Pwned!")</script>';
$mech->get_ok ( '/?title=">' . $payload, '[GET /] OK' );
isnt ( index ( $mech->content, $payload ), -1, '[GET /] has XSS payload' );
