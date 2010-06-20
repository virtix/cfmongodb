<cfcomponent extends="BaseTest">
<!--- 
  In a single file, implement multiple models
 --->
<cfscript>

config = {
  server_name = 'localhost',
  server_port = 27017,
  db_name = 'dev_db',
  collection_name = 'test'	
 };
 
function testEachIterator(){
 mongo = createObject('component','cfmongodb.components.MongoDB');
 mongo.getDb('goodcoders');
 doc = mongo.new_doc('person');
 doc.set('name','bill');
 doc.save();
 
 
}

</cfscript>
</cfcomponent>