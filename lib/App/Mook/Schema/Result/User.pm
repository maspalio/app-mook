use utf8;
package App::Mook::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

App::Mook::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'text'
  is_nullable: 0

=head2 pass

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "text", is_nullable => 0 },
  "pass",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 notes

Type: has_many

Related object: L<App::Mook::Schema::Result::Note>

=cut

__PACKAGE__->has_many(
  "notes",
  "App::Mook::Schema::Result::Note",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-01-23 14:33:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UWtWj6sf+UcuoREZkA2ggw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
