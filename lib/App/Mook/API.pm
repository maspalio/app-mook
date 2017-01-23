package App::Mook::API;

use Dancer2;

use App::Mook::API::Note;

sub get_app {
  return App::Mook::API->to_app;
}

true;
