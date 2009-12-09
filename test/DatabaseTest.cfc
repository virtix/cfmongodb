<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>

function smokeTest(){
  assertSame( db, db );
}

function getDefaultPort(){
  assert ( db.port == 27017 );
}

function getDefaultServer(){
  assert ( db.server == 'localhost' );
}


function setUp(){
 db = createObject('component','cfmongodb.DB').init();
}

</cfscript>
</cfcomponent>