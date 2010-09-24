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

	function save(struct doc, string coll, mongoConfig=""){
	   var collection = getMongoDBCollection(mongoConfig,coll);
	   var bdbo =  mongoUtil.newDBObjectFromStruct(doc);
	   collection.insert([bdbo]);
	   doc["_id"] =  bdbo.get("_id");
	   return doc["_id"];
	}

	function saveAll(array docs, string coll, mongoConfig=""){
		var collection = getMongoDBCollection(mongoConfig,coll);
		var i = 1;
		var total = arrayLen(docs);
		var allDocs = [];
		for(i=1; i LTE total; i++){
			arrayAppend( allDocs, mongoUtil.newDBObjectFromStruct(docs[i]) );
		}
		collection.insert(allDocs);
		return docs;
	}


	function query(string coll, mongoConfig=""){
	   var db = getMongoDB(mongoConfig);
	   return new SearchBuilder(coll,db,mongoUtil);
	}


	function update(doc, coll, query={}, upsert=false, multi=false, mongoConfig=""){
	   var collection = getMongoDBCollection(mongoConfig,coll);

	   if(structIsEmpty(query)){
		  query = mongoUtil.newIDCriteriaObject(doc['_id'].toString());
	   } else{
	   	  query = mongoUtil.newDBObjectFromStruct (query);
	   }

	   var dbo = mongoUtil.newDBObjectFromStruct(doc);

	  collection.update( query, dbo, upsert, multi );
	} //end function



	function remove(doc,coll,mongoConfig=""){
	   var collection = getMongoDBCollection(mongoConfig,coll);
	   var dbo = mongoUtil.newDBObjectFromStruct(doc);
	   collection.remove( dbo );
	} //end function

	/**
	* So important we need to provide top level access to it and make it as easy to use as possible.

	FindAndModify is critical for queue-like operations. Its atomicity removes the traditional need to synchronize higher-level methods to ensure queue elements only get processed once.

	http://www.mongodb.org/display/DOCS/findandmodify+Command

		This function assumes you are using this to *apply* additional changes to the "found" document. If you wish to overwrite, pass overwriteExisting=true. One bristles at the thought

	*/
	function findAndModify(struct query, struct fields={}, struct sort={"_id"=1}, boolean remove=false, struct update, boolean returnNew=true, boolean upsert=false, boolean overwriteExisting=false, string coll){
		var collection = getMongoDBCollection (MongoConfig,coll);
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
	public array function ensureIndex(array fields, coll, unique=false, mongoConfig=""){
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

	 	var dbo = mongoUtil.newDBObjectFromStruct( doc );
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
			MongoConfig = variables.mongoConfig;
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
