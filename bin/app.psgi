#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use App::Mook;
use App::Mook::API;
use App::Mook::NOT;

use Plack::Builder;

builder {
  enable 'Static',
    path => qr/ ^ \/ (?: css|images|javascripts ) \/ /x,
    root => 'public/';

  mount '/'    => App::Mook->get_app;
  mount '/api' => App::Mook::API->get_app;
  mount '/not' => App::Mook::NOT->get_app;
};
