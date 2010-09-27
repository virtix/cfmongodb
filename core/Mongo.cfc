<cfcomponent accessors="true">

	<cfproperty name="mongoConfig">
	<cfproperty name="mongoFactory">
	<cfproperty name="mongoUtil">

<cfscript>

	function init(MongoConfig="#createObject('MongoConfig')#", MongoFactory="#createObject('DefaultFactory')#"){
		setMongoConfig(arguments.MongoConfig);
		setMongoFactory(arguments.MongoFactory);
		variables.mongo = mongofactory.getObject("com.mongodb.Mongo");
		var cfg = variables.mongoConfig.getDefaults();
		variables.mongo.init(cfg.server_name,cfg.server_port);
		mongoUtil = new MongoUtil(mongoFactory);
		return this;
	}

	function query(string coll, mongoConfig=""){
	   var db = getMongoDB(mongoConfig);
	   return new SearchBuilder(coll,db,mongoUtil);
	}

	function save(struct doc, string collectionName, mongoConfig=""){
	   var collection = getMongoDBCollection(collectionName, mongoConfig);
	   var bdbo =  mongoUtil.newDBObjectFromStruct(doc);
	   collection.insert([bdbo]);
	   doc["_id"] =  bdbo.get("_id");
	   return doc["_id"];
	}

	function saveAll(array docs, string collectionName, mongoConfig=""){
		var collection = getMongoDBCollection(collectionName, mongoConfig);
		var i = 1;
		var total = arrayLen(docs);
		var allDocs = [];
		for(i=1; i LTE total; i++){
			arrayAppend( allDocs, mongoUtil.newDBObjectFromStruct(docs[i]) );
		}
		collection.insert(allDocs);
		return docs;
	}

	function update(doc, collectionName, query={}, upsert=false, multi=false, mongoConfig=""){
	   var collection = getMongoDBCollection(collectionName, mongoConfig);

	   if(structIsEmpty(query)){
		  query = mongoUtil.newIDCriteriaObject(doc['_id'].toString());
	   } else{
	   	  query = mongoUtil.newDBObjectFromStruct(query);
	   }

	   var dbo = mongoUtil.newDBObjectFromStruct(doc);

	   collection.update( query, dbo, upsert, multi );
	}

	function remove(doc, collectionName, mongoConfig=""){
	   var collection = getMongoDBCollection(collectionName, mongoConfig);
	   var dbo = mongoUtil.newDBObjectFromStruct(doc);
	   collection.remove( dbo );
	}

	/**
	* So important we need to provide top level access to it and make it as easy to use as possible.

	FindAndModify is critical for queue-like operations. Its atomicity removes the traditional need to synchronize higher-level methods to ensure queue elements only get processed once.

	http://www.mongodb.org/display/DOCS/findandmodify+Command

	This function assumes you are using this to *apply* additional changes to the "found" document. If you wish to overwrite, pass overwriteExisting=true. One bristles at the thought

	*/
	function findAndModify(struct query, struct fields={}, struct sort={"_id"=1}, boolean remove=false, struct update, boolean returnNew=true, boolean upsert=false, boolean overwriteExisting=false, string collectionName, mongoConfig=""){
		var collection = getMongoDBCollection(collectionName, mongoConfig);
		//must apply $set, otherwise old struct is overwritten
		if(not structKeyExists( update, "$set" ) and NOT overwriteExisting){
			update = { "$set" = mongoUtil.newDBObjectFromStruct(update)  };
		}
		var updated = collection.findAndModify(
			mongoUtil.newDBObjectFromStruct(query),
			mongoUtil.newDBObjectFromStruct(fields),
			mongoUtil.newDBObjectFromStruct(sort),
			remove,
			mongoUtil.newDBObjectFromStruct(update),
			returnNew,
			upsert
		);
		if( isNull(updated) ) return {};

		return mongoUtil.dbObjectToStruct(updated);
	}



	/**
	* the array of fields can either be
	a) an array of field names. The sort direction will be "1"
	b) an array of structs in the form of fieldname=direction. Eg:

	[
		{lastname=1},
		{dob=-1}
	]

	*/
	public array function ensureIndex(array fields, collectionName, unique=false, mongoConfig=""){
	 	var collection = getMongoDBCollection(collectionName, mongoConfig);
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

	 	var dbo = mongoUtil.newDBObjectFromStruct( doc );
	 	collection.ensureIndex( dbo, "_#indexName#_", unique );

	 	return getIndexes(collectionName, mongoConfig);
	}

	public array function getIndexes(collectionName, mongoConfig=""){
		var collection = getMongoDBCollection(collectionName, mongoConfig);
		var indexes = collection.getIndexInfo().toArray();
		return indexes;
	}

	public array function dropIndexes(collectionName, mongoConfig=""){
		getMongoDBCollection( collectionName, mongoConfig ).dropIndexes();
		return getIndexes( collectionName, mongoConfig );
	}

	//decide whether to use the one in the variables scope, the one being passed around as arguments, or create a new one
	function getMongoConfig(mongoConfig=""){
		if(isSimpleValue(arguments.mongoConfig)){
			mongoConfig = variables.mongoConfig;
		}
		return mongoConfig;
	}

	/* Provide access to the most common java objects */
	function getMongo(mongoConfig=""){
		return variables.mongo;
	}

	function getMongoDB(mongoConfig=""){
		var jMongo = getMongo(mongoConfig);
		return jMongo.getDb(getMongoConfig(mongoConfig).getDefaults().db_name);
	}

	function getMongoDBCollection(collectionName="", mongoConfig=""){
		var jMongoDB = getMongoDB(mongoConfig);
		return jMongoDB.getCollection(collectionName);
	}

</cfscript>

</cfcomponent>
