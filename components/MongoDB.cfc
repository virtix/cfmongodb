<cfcomponent extends="MongoBase" output="false" hint="Facade for Mongo DB. 90% of calls will go through this component.">

<cfscript>
//This maybe should be a config object
config = {
  server_name = 'localhost',
  server_port = 27017,
  db_name = 'default_db',
  collection_name = ''
 };


//maybe this goes in super class? Or make factory for returning mongos
/*--------------------------------------------------------------------
         mongo1 = factory.createMongo(config);
--------------------------------------------------------------------*/
mongo = createObject('java', 'com.mongodb.Mongo').init( variables.config.server_name , variables.config.server_port );

function init(config){
 variables.config = arguments.config;
 mongo = createObject('java', 'com.mongodb.Mongo').init( variables.config.server_name , variables.config.server_port );
 return this;
}

/**
* Returns the java com.mongodb.Mongo object... with this, you can do anything available in the java API
*/
function getMongo(){
 return mongo;
}

/**
* Get a handle to a mongo db
*/
function getMongoDb(dbName="#variables.config.db_name#"){
	return mongo.getDb(dbName);
}

/**
* Get a handle to a mongo db's collection
*/
function getMongoCollection(dbName="#variables.config.db_name#",collectionName="#variables.config.collection_name#"){
	return mongo.getDb(dbName).getCollection(collectionName);
}

/**
* Get a new cfmongodb Database object
*/
function db(String dbName){
	return createObject("component","Database").init(dbName);
}

/**
* Get a new cfmongodb Collection object
*/
function collection(String dbName, String collectionName){
	return db(dbName).getCollection(collectionName);
}


  /*---------------------------------------------------------------------

    DSL for MongoDB searches:

    results = mongo.db('mydb').collection('blog').
                    startsWith('name','foo').  //string
                    endsWith('title','bar').   //string
                    exists('field','value').   //string
					regex('field','value').    //string
					before('field', 'value').  //date
					after('field', 'value').   //date
                    $eq('field','value').      //numeric
                    $gt('field','value').      //numeric
                    $gte('field','value').     //numeric
                    $lte('field','value').     //numeric
                    $in('field','value').      //array
                    $nin('field','value').     //array
                    $mod('field','value').     //numeric
                    size('field','value').     //numeric
                    search('title,author,date', limit, start);

    search(keys=list_of_keys_to_return,sort={field=direction},limit=num,start=num);




-------------------------------------------------------------------------------------*/


function new_doc(collection_name){
   var document = createObject('component','MongoDocument').factory_init( collection_name, this );
   return document;
}


// The following functions are all conveniences for the most-common operations; they wrap around
//the "proper" Collection methods.



/* !!!!!!!!!!!!!!     Inserts and Upserts    !!!!!!!!!!!!!!!!!!! */

/**
* @param structure
*/
function insert(structure,dbName="#variables.config.db_name#",collectionName="#variables.config.collection_name#"){
 return collection(dbName,collectionName)
 	.insert(structure);
}//end function


function update(structure,dbName="#variables.config.db_name#",collectionName="#variables.config.collection_name#"){
  return collection(dbName,collectionName)
  	.update(structure);

} //end function



/*!!!!!!!!!!!!!!!!!         Find                  !!!!!!!!!!!!!! */

function findOne(field="",value="",dbName="#variables.config.db_name#",collectionName="#variables.config.collection_name#"){
  return collection(dbName,collectionName).findOne(field,value);
} //end function


//when only a string id is available
function findById(id,dbName="#variables.config.db_name#",collectionName="#variables.config.collection_name#"){
  var objId = newIDCriteriaObject(id);
  return findOne("_id", objId,dbName,collectionName);
 } //end function


function findAll(dbName="#variables.config.db_name#",collectionName="#variables.config.collection_name#"){
   var sort = {pub_date = -1};
   var sort_spec =  newDBObjectFromStruct(sort);
   return collection(dbName,collectionName).find().sort( sort_spec ).toArray();
} //end function

function count(dbName="#variables.config.db_name#",collectionName="#variables.config.collection_name#"){
  return collection(dbName,collectionName).getCount();
}




/* !!!!!!!!!!!!!!!        Remove      !!!!!!!!!!!!!!!!!!!!*/


function remove(structure,dbName="#variables.config.db_name#",collectionName="#variables.config.collection_name#"){
  var dbo = newDBObjectFromStruct(arguments.structure);

  return collection(dbName,collectionName)
  	.remove(dbo);
}

//Note the ObjectId object. This creates an ObjectId from
//the string representation of

function removeById(id,dbName="#variables.config.db_name#",collectionName="#variables.config.collection_name#"){
  return collection(dbName,collectionName).remove(id); //id's of deleted items
}


function listToStruct(list){
  var item = '';
  var s = {};
  var i = 1;
  for(i; i lte listlen(list); i++) {
   s.put(listgetat(list,i),1);
  }
  return s;
}

</cfscript>


<cffunction name="search">
  <cfargument name="keys" type="string" required="false" default="" hint="A list of keys to return" />
  <cfargument name="limit" type="numeric" required="false" default="0" hint="Number of the maximum items to return" />
  <cfargument name="sort" type="struct" required="false" default="#structNew()#" hint="A struct representing how the items are to be sorted" />
  <cfscript>
   var key_exp = listToStruct(arguments.keys);
   var _keys = createObject('java', 'com.mongodb.BasicDBObject').init(key_exp);
   var search_results = [];
   var criteria = expression_builder.get();
   var q = createObject('java', 'com.mongodb.BasicDBObject').init(criteria);
   search_results = collection.find(q,_keys).limit(limit);
   return search_results;
  </cfscript>
</cffunction>

</cfcomponent>