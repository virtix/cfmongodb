<cfcomponent accessors="true">

	<cfproperty name="mongoConfig">
	<cfproperty name="mongoFactory">
	<cfproperty name="mongoUtil">

<cfscript>

	function init(MongoConfig="#createObject('MongoConfig')#"){
		setMongoConfig(arguments.MongoConfig);
		setMongoFactory(mongoConfig.getMongoFactory());
		variables.mongo = mongofactory.getObject("com.mongodb.Mongo");

		if( arrayLen( mongoConfig.getServers() ) GT 1 ){
			variables.mongo.init(variables.mongoConfig.getServers());
		} else {
			var server = mongoConfig.getServers()[1];
			variables.mongo.init( server.getHost(), server.getPort() );
		}

		mongoUtil = new MongoUtil(mongoFactory);
		return this;
	}

	function close(){
		try{
			variables.mongo.close();
		}catch(any e){
			//the error that this throws *appears* to be harmless.
			writeLog("Error closing Mongo: " & e.message);
		}
	}

	//for simple mongo _id searches.
	function findById( id, string collectionName, mongoConfig="" ){
		var collection = getMongoDBCollection(collectionName, mongoConfig);
		var result = collection.findOne( mongoUtil.newIDCriteriaObject(id) );
		return mongoUtil.toCF( result );
	}

	function query(string collectionName, mongoConfig=""){
	   var db = getMongoDB(mongoConfig);
	   return new SearchBuilder(collectionName,db,mongoUtil);
	}

	function save(struct doc, string collectionName, mongoConfig=""){
	   var collection = getMongoDBCollection(collectionName, mongoConfig);
	   var bdbo =  mongoUtil.toMongo(doc);
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
			arrayAppend( allDocs, mongoUtil.toMongo(docs[i]) );
		}
		collection.insert(allDocs);
		return docs;
	}

	function update(doc, collectionName, query={}, upsert=false, multi=false, mongoConfig=""){
	   var collection = getMongoDBCollection(collectionName, mongoConfig);

	   if(structIsEmpty(query)){
		  query = mongoUtil.newIDCriteriaObject(doc['_id'].toString());
	   } else{
	   	  query = mongoUtil.toMongo(query);
	   }

	   var dbo = mongoUtil.toMongo(doc);

	   collection.update( query, dbo, upsert, multi );
	}

	function remove(doc, collectionName, mongoConfig=""){
	   var collection = getMongoDBCollection(collectionName, mongoConfig);
	   if( structKeyExists(doc, "_id") ){
	   	return removeById( doc["_id"], collectionName, mongoConfig );
	   }
	   var dbo = mongoUtil.toMongo(doc);
	   var writeResult = collection.remove( dbo );
	   return writeResult;
	}

	function removeById( id, collectionName, mongoConfig="" ){
		var collection = getMongoDBCollection(collectionName, mongoConfig);
		return collection.remove( mongoUtil.newIDCriteriaObject(id) );
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
			update = { "$set" = mongoUtil.toMongo(update)  };
		}
		var updated = collection.findAndModify(
			mongoUtil.toMongo(query),
			mongoUtil.toMongo(fields),
			mongoUtil.toMongo(sort),
			remove,
			mongoUtil.toMongo(update),
			returnNew,
			upsert
		);
		if( isNull(updated) ) return {};

		return mongoUtil.toCF(updated);
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

	 	var dbo = mongoUtil.toMongo( doc );
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
		return jMongo.getDb(getMongoConfig(mongoConfig).getDefaults().dbName);
	}

	function getMongoDBCollection(collectionName="", mongoConfig=""){
		var jMongoDB = getMongoDB(mongoConfig);
		return jMongoDB.getCollection(collectionName);
	}

</cfscript>

</cfcomponent>
