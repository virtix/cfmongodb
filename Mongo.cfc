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
function add(key,value,o){
  //add key value pair to object ... todo
}

function put(o){ 
 var doc =  createObject('java', 'com.mongodb.BasicDBObject').init();
 var id = chr(0);
  doc.putAll(o);
  id = collection.insert(doc).get("_id");
  o._id = id;
  return id;
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


function delete(o){
  var  obj = get("_id", o._id);
  return collection.remove(obj); //id's of deleted items
} //end function




//old
function __delete(field,value){
  var q = createObject('java', 'com.mongodb.BasicDBObject').init(field,value);
  return collection.remove(q); //id's of deleted items
} //end function



//ideally, we would have an object that when called would update itself
//however, when working with structs, we need to tell MongoDB, which 
//item we want to update, since we are not maintaining the string id
//in the structure.

//update by object id  ..._id

//testing if pass in map what it return
function findSame(o){
 var new_object = createObject('java', 'com.mongodb.BasicDBObject').init(o);
 return collection.findOne(new_object);
}

function update(o){
  var obj = get("_id", o._id);
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