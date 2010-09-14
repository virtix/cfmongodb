<cfcomponent>
<cfscript>

util = new MongoUtil();

function init(MongoConfig="#createObject('MongoConfig')#"){
	variables.config = arguments.MongoConfig;
	variables.mongo = createObject('java', 'com.mongodb.Mongo');
	var cfg = variables.config.getDefaults();
	variables.mongo.init(cfg.server_name,cfg.server_port);
	return this;
}

function save(struct doc, string coll, mongoConfig=""){
   var collection = getMongoDBCollection(mongoConfig,coll);
   var bdbo =  util.newDBObjectFromStruct(doc);
   collection.insert([bdbo]);

   var _id = bdbo.get("_id");
   request.debug(_id);
   doc["_id"] = _id;
   return _id;
}


function query(string coll, mongoConfig=""){
   var db = getMongoDB(mongoConfig);
   return new SearchBuilder(coll,db);
}


function update(doc,coll,mongoConfig=""){
   var collection = getMongoDBCollection(mongoConfig,coll);
   var crit = util.newIDCriteriaObject(doc['_id'].toString());
   var dbo = util.newDBObjectFromStruct(doc);
   collection.update( crit, dbo );
} //end function



function remove(doc,coll,mongoConfig=""){
   var collection = getMongoDBCollection(mongoConfig,coll);
   var dbo = util.newDBObjectFromStruct(doc);
   collection.remove( dbo );
} //end function


//decide whether to use the one in the variables scope, the one being passed around as arguments, or create a new one
function getMongoConfig(MongoConfig=""){
	if(isSimpleValue(arguments.MongoConfig)){
		MongoConfig = variables.config;
	}
	return MongoConfig;
}

/* Provide access to the most common java objects */
function getMongo(MongoConfig=""){
	return variables.mongo;
}

function getMongoDB(MongoConfig=""){
	var jMongo = getMongo(MongoConfig);
	return jMongo.getDb(getMongoConfig(MongoConfig).getDefaults().db_name);
}

function getMongoDBCollection(MongoConfig="",CollectionName=""){
	var jMongoDB = getMongoDB(MongoConfig);
	return jMongoDB.getCollection(collectionName);
}


public void function ensureIndex(array names){
  throw ("to do");
}


</cfscript>


</cfcomponent>