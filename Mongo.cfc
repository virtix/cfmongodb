<cfcomponent output="false">
<!--- Maybe should extend an Abstract Mongo? --->

<cfscript>
//And this is configurable.
server_name = 'localhost';
server_port = 27017;
db_name = 'default_db';
collection_name = 'default_collection';	
	
//maybe this goes in super class	
mongo = createObject('java', 'com.mongodb.Mongo').init( variables.server_name , variables.server_port );
db = mongo.getDb(db_name);
collection = db.getCollection(collection_name);


//------------------------------------------------------------------------//

function put(){ 
 var doc =  createObject('java', 'com.mongodb.BasicDBObject').init();
  if(arguments.size() eq 1){
    doc.putAll(arguments[1]);
  }
  else {
   doc.put(arguments[1],arguments[2]);
  }
  
  return collection.insert(doc).get("_id");
}//end function



function get(field,value){
  var q = createObject('java', 'com.mongodb.BasicDBObject').init(field,value);
  var cursor = collection.find(q);
  return cursor.next();
} //end function


function count(){
  return collection.getCount();
}

function find(){

} //end function



function delete(field,value){
  var q = createObject('java', 'com.mongodb.BasicDBObject').init(field,value);
  return collection.remove(q); //id's of deleted items
} //end function


function update(o){
  var q = createObject('java', 'com.mongodb.BasicDBObject').init(o);
  return collection.save(q);
} //end function



//not tested ...
function switchCollection(collection_name){
  collection = db.getCollection(collection_name);
}

</cfscript>

<cffunction name="dump">
  <cfdump var="#doc#">
</cffunction>
</cfcomponent>