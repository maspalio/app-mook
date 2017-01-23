requires "Dancer2::Plugin::DBIC";
requires "Dancer2::Plugin::REST";
requires "Dancer2";
requires "DBD::SQLite";
requires "Digest::MD5";
requires "Net::Server::SS::PreFork";
requires "Plack::Middleware::Headers";
requires "Server::Starter";
requires "Starman";
requires "Template"; # aka Template::Toolkit

recommends "CGI::Deurl::XS";
recommends "Class::XSAccessor";
recommends "Crypt::URandom";          # Dancer2::Core::Role::SessionFactory
#recommends "EV";
recommends "HTTP::Parser::XS";
recommends "Math::Random::ISAAC::XS"; # Dancer2::Core::Role::SessionFactory
recommends "Scope::Upper";
recommends "URL::Encode::XS";
requires "Cpanel::JSON::XS";
requires "YAML::XS";

on "test" => sub {
  requires "HTTP::Cookies";
  requires "HTTP::Request::Common";
  requires "Test::More";
  requires "Test::WWW::Mechanize::PSGI";
};

on "develop" => sub {
  requires "DBIx::Class::Schema::Loader";
};
