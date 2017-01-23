$( window ).on ( "load", function () {
  $( "#notes" ).on ( "change", function () {
    var val = $( this ).val ();
    
    if ( val == "+" ) {
      $( "#note"  ).val ( "" );
      $( "#title" ).val ( "" );
      
      $( "#create" ).prop ( "disabled", false );
      $( "#update" ).prop ( "disabled", true );
      $( "#delete" ).prop ( "disabled", true );
    }
    else {
      var url = "/api/note/" + val + ".json";

      $.ajax ({
        url: url
      , success: function ( data ) {
          $( "#note"  ).val ( data.content );
          $( "#title" ).val ( data.title   );

          $( "#create" ).prop ( "disabled", true );
          $( "#update" ).prop ( "disabled", false );
          $( "#delete" ).prop ( "disabled", false );
        }
      });
    }
  } );
  
  $( "#create" ).on ( "click", function () {
    var url  = "/api/note.json";
    var data = { title: $( "#title" ).val (), content: $( "#note" ).val () };
    
    $.ajax ({
      url: url
    , type: "POST"
    , dataType: "JSON"
    , data: data
    , success: function ( data ) {
        $( "#notes" ).append ( $( "<option></option>" ).val ( data.id ).html ( data.title ) ).val ( data.id );
      }
    });
  } );
  
  $( "#update" ).on ( "click", function () {
    var val   = $( "#notes" ).val ();
    var url   = "/api/note/" + val + ".json";
    var title = $( "#title" ).val ()
    var data  = { title: title, content: $( "#note" ).val () };
    
    $.ajax ({
      url: url
    , type: "PUT"
    , data: data
    , statusCode: {
        205: function () {
          $( "#notes option[value=" + val + "]" ).text ( title );
        }
      }
    });
  } );
  
  $( "#delete" ).on ( "click", function () {
    var val = $( "#notes" ).val ();
    var url = "/api/note/" + val + ".json";
    
    $.ajax ({
      url: url
    , type: "DELETE"
    , success: function () {
        $( "#notes option[value=" + val + "]" ).remove ();

        $( "#note"  ).val ( ""  );
        $( "#title" ).val ( ""  );
        $( "#notes" ).val ( "+" );
      }
    });
  } );
} );
