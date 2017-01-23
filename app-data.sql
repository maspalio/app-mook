-- cat app-data.sql | sqlite3 app.db
-- sqlite3 app.db 'SELECT * FROM user ORDER BY id'
-- sqlite3 app.db 'SELECT * FROM note ORDER BY title'

BEGIN;

DELETE FROM user;

INSERT INTO user ( id, pass ) VALUES ( 'jdoe', 'e9f5bd2bae1c70770ff8c6e6cf2d7b76' );

DELETE FROM note;
DELETE FROM sqlite_sequence where name = 'note';

INSERT INTO note ( user_id, title, content ) VALUES ( 'jdoe', 'Margarita', '2 oz silver tequila
1 oz Cointreau
1 oz fresh-squeezed lime juice

Rub a lime wedge over the rim of a rocks glass (or Margarita glass) then twist on a plate of coarse salt so it attaches. Shake the ingredients with cracked ice, then strain into a glass over ice.' );
INSERT INTO note ( user_id, title, content ) VALUES ( 'jdoe', 'Sidecar', '2 oz Cognac
3/4 oz Cointreau
3/4 oz fresh-squeezed lemon juice

Twist the rim of a coupe into a plate of sugar so it attaches to the glass''s rim. Add all ingredients to a cocktail shaker with ice and shake until chilled. Strain into sugar-rimmed coupe and garnish with an orange peel.' );
INSERT INTO note ( user_id, title, content ) VALUES ( 'jdoe', 'Daiquiri', '2 oz white rum 
1 oz fresh-squeezed lime juice
3/4 oz simple syrup

Combine ingredient in a mixing glass with ice and shake well. Strain into a coupe.' );
INSERT INTO note ( user_id, title, content ) VALUES ( 'jdoe', 'Manhattan', '2 oz rye whiskey
1 oz sweet vermouth
2 dashes Angostura bitters

Stir the ingredients with cracked ice, then strain into in a chilled coupe. Garnish with an orange twist or brandied cherry (none of that cheap maraschino bullshit).' );

COMMIT;
