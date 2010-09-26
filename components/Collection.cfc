<cfcomponent extends="MongoBase" output="false" hint="Represents a Mongo Collection">



<!---
Operations on Collections:


--->

	<cfscript>
	//if you don't init, you must quit (coding, that is)
	function init(mongo,dbName,collectionName){
		variables.mongo = arguments.mongo;
		variables.db = mongo.getDb(dbName);
		variables.collection = variables.db.getCollection(collectionName);
		return this;
	}


	// !!! Find !!!!

	function findOne(field="",value=""){
	  var query = newDBObject(field,value);
	  if(field eq ""){
	  	query = newDBObjectFromStruct({});
	  }
	  return collection.findOne(query);
	}


	//when only a string id is available
	function findById(id){
	  var objId = newIDCriteriaObject(id);
	  return findOne("_id", objId,dbName,collectionName);
	 }

	function findAll(){
	   var sort = {pub_date = -1}; // TODO: figure out wtf this is
	   var sort_spec =  newDBObjectFromStruct(sort);
	   return collection.find().sort( sort_spec ).toArray();
	}

	function count(){
	  return collection.getCount();
	}

	// !!! Insert and Upsert !!!
	function insert(structure){
		var doc =  newDBObjectFromStruct(structure);
		var id = chr(0);
		collection.insert(doc);
		id = doc.get("_id");
		structure._id = id; //add the _id object to the struct
		return id;
	}

	function update(structure){
		var newObject = newDBObjectFromStruct(structure);
		if(structKeyExists(structure,"_id")){
			critera = newIDCriteriaObject(structure._id);
			return collection.update(criteria, newObject, true, false);
		}else{
			return collection.insert(newObject);
		}
	}



	// !!! Remove !!!

	function remove(criteria){
		var doc = newDBObjectFromStruct(criteria);
		return collection.remove(doc);

	}

	//Note the ObjectId object. This creates an ObjectId from
	//the string representation of

	function removeById(id){
	  var objId = newIDCriteriaObject(id);
	  return collection.remove(objID); //id's of deleted items
	}



	</cfscript>

</cfcomponent>