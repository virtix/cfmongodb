<cfcomponent  output="false">
<cfscript>
/* -------------------------------------------------
	Example of a condensed model.  Instead of separate
	files for each class, multiple "classes" can be 
	defined here using the mongo document factory.
----------------------------------------------------*/
config = {
  server_name = 'localhost',
  server_port = 27017,
  db_name = 'dev',
  collection_name = 'test_coll'	
 };

mongo = createObject('component','cfmongodb.components.MongoDb').init(config);


function new_person(name,addr){
   var person = mongo.new_doc('person',mongo);
   person.set('name',name);
   person.set('address',addr);
   return person;
}
	
	
</cfscript>
</cfcomponent>