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
   doc["_id"] =  bdbo.get("_id");
   return doc["_id"];
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

/**
* the array of fields can either be
a) an array of field names. The sort direction will be "1"
b) an array of structs in the form of fieldname=direction. Eg:

[
	{lastname=1},
	{dob=-1}
]

*/
public array function ensureIndex(coll, mongoConfig="", array fields, unique=false){
 	var collection = getMongoDBCollection(mongoConfig, coll);
 	var pos = 1;
 	var doc = {};
	var indexName = "";
	var fieldName = "";

 	for( pos = 1; pos LTE arrayLen(fields); pos++ ){
		if( isSimpleValue(fields[pos]) ){
			fieldName = fields[pos];
			doc[ fieldName ] = 1;
		} else {
			fieldName = structKeyList(fields[pos]);
			doc[ fieldName ] = fields[pos][fieldName];
		}
		indexName = listAppend( indexName, fieldName, "_");
 	}

 	var dbo = util.newDBObjectFromStruct( doc );
 	collection.ensureIndex( dbo, "_#indexName#_", unique );

 	return getIndexes(coll, mongoConfig);
}

public array function getIndexes(coll, mongoConfig=""){
	var collection = getMongoDBCollection(mongoConfig, coll);
	var indexes = collection.getIndexInfo().toArray();
	return indexes;
}

public array function dropIndexes(coll, mongoConfig=""){
	getMongoDBCollection( mongoConfig, coll ).dropIndexes();
	return getIndexes( coll, mongoConfig );
}

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




</cfscript>


</cfcomponent>