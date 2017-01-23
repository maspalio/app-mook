use utf8;
package App::Mook::Schema::Result::Note;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Mook::Schema::Result::Note

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<note>

=cut

__PACKAGE__->table("note");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'text'
  is_nullable: 0

=head2 content

  data_type: 'text'
  is_nullable: 0

=head2 user_id

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 0 },
  "content",
  { data_type => "text", is_nullable => 0 },
  "user_id",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<App::Mook::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "App::Mook::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-01-23 14:33:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:insaj/3SgV/iuatXRpmwRA

sub as_h {
  my ( $self ) = @_;
  
  my %h = $self->get_columns;
  
  return \%h;
}

1;
