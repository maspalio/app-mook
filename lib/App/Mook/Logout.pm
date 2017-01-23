package App::Mook::Logout;

use Dancer2 appname => 'App::Mook';

get '/logout' => sub {
  app->destroy_session;

  redirect '/';
};

true;
