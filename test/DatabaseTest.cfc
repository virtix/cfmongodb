<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>
 function testThis(){
   db = createObject('component','cfmongodb.components.Database');
   debug(db.getDB('default_db'));
 }

</cfscript>
</cfcomponent>