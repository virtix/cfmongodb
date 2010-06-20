<cfcomponent>
<cfscript>


public any function save(struct doc, string coll){
   var config = new MongoConfig().getDefaults();
   var mongo = createObject('java', 'com.mongodb.Mongo').init( config.server_name , config.server_port );
   var collection = mongo.getDb(config.db_name).getCollection(coll);  
   var bdbo =  createObject('java', 'com.mongodb.BasicDBObject').init(doc);
   collection.insert(bdbo);
   return collection.findOne(bdbo).get("_id");
}



public any function query(string coll){
   var config = new MongoConfig().getDefaults();
   var mongo = createObject('java', 'com.mongodb.Mongo').init( config.server_name , config.server_port );
   var db = mongo.getDb(config.db_name);
   return new SearchBuilder(coll,db);
}


function update(doc,coll){
   var config = new MongoConfig().getDefaults();
   var mongo = createObject('java', 'com.mongodb.Mongo').init( config.server_name , config.server_port );
   var collection = mongo.getDb(config.db_name).getCollection(coll);  
   var id = doc['_id'].toString();
   var oid = createObject("java","org.bson.types.ObjectId").init(id);
   var crit = createObject("java","com.mongodb.BasicDBObject").init('_id',oid);
   var dbo = createObject("java","com.mongodb.BasicDBObject").init(doc);
   collection.update( crit, dbo );
} //end function



function remove(doc,coll){
   var config = new MongoConfig().getDefaults();
   var mongo = createObject('java', 'com.mongodb.Mongo').init( config.server_name , config.server_port );
   var collection = mongo.getDb(config.db_name).getCollection(coll);  
   var dbo = createObject("java","com.mongodb.BasicDBObject").init(doc);
   collection.remove( dbo );
} //end function


public void function ensureIndex(array names){
  throw ("to do");
}


</cfscript>


</cfcomponent>