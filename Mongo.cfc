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
 //var o = arguments[1];
  if(arguments.size() eq 1){
    doc.putAll(arguments[1]);
    arguments[1]._id = doc.get("_id"); 
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



//ideally, we would have an object that when called would update itself
//however, when working with structs, we need to tell MongoDB, which 
//item we want to update, since we are not maintaining the string id
//in the structure.

//update by object id  ..._id
function update(_id,o){
  var obj = get("_id", _id);
  var new_object = createObject('java', 'com.mongodb.BasicDBObject').init(o);
  return collection.update(obj, new_object, false, false);
    
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