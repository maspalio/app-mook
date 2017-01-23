package App::Mook::NOT;

use Dancer2;

use App::Mook::NOT::Note;

sub get_app {
  return App::Mook::NOT->to_app;
}

true;
