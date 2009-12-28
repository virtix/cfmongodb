<cfcomponent output="false" hint="Facade for Mongo DB. 90% of calls will go through this comonent.">

<cfscript>
//This maybe should be a config object
config = {
  server_name = 'localhost',
  server_port = 27017,
  db_name = 'default_db',
  collection_name = 'default_collection'	
 };

	
//maybe this goes in super class? Or make factory for returning mongos
/*--------------------------------------------------------------------
         mongo1 = factory.createMongo(config); 
--------------------------------------------------------------------*/	
mongo = createObject('java', 'com.mongodb.Mongo').init( variables.config.server_name , variables.config.server_port );
db = mongo.getDb(config.db_name);	
collection = db.getCollection(config.collection_name);
expression_builder = createObject('component', 'ExpressionBuilder') ;


function init(config){
 variables.config = arguments.config;
 mongo = createObject('java', 'com.mongodb.Mongo').init( variables.config.server_name , variables.config.server_port );
 db = mongo.getDb(config.db_name);	
 collection = db.getCollection(config.collection_name);
 return this;
}


function config(){

}

  /*---------------------------------------------------------------------
  
    DSL for MongoDB searches:   
    
    results = mongo.collection('blog').
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

builder = createObject('component','ExpressionBuilder');

function new_doc(collection_name){
   var document = createObject('component','MongoDocument').factory_init( collection_name, this );
   return document;
}
	

function getMongo(){
 return mongo;
}

//------------------------------------------------------------------------//
function add(key,value,o){
  //add key value pair to object ... todo
}

/**
* @param o string
*/
function put(o){ 
 var doc =  createObject('java', 'com.mongodb.BasicDBObject').init();
 var id = chr(0);
  doc.putAll(o);
  id = collection.insert(doc).get("_id");
  o._id = id; //add the _id object to the struct
  return id;
}//end function



function get(field,value){
  var q = createObject('java', 'com.mongodb.BasicDBObject').init(field,value);
  var cursor = collection.find(q);
  return cursor.next();
} //end function


//when only a string id is available
function getById(id){
  var objId = createObject('java','com.mongodb.ObjectId').init(id);
  return get("_id", objId);
 } //en


function count(){
  return collection.getCount();
}


function findOne(){
  return collection.findOne();
} //


function findAll(){
   var sort = {pub_date = -1};
   var sort_spec =  createObject('java', 'com.mongodb.BasicDBObject').init(sort);	
   return collection.find().sort( sort_spec ).toArray(); 
} //end function


function delete(o){
  var  obj = get("_id", o._id);
  return collection.remove(obj); //id's of deleted items
} //end function


//Note the ObjectId object. This creates an ObjectId from
//the string representation of 

function deleteById(id){
  var objId = createObject('java','com.mongodb.ObjectId').init(id);
  var  obj = get("_id", objId);
  return collection.remove(obj); //id's of deleted items
} //en


function update(o){
  var obj = get("_id", o._id);
  var new_object = createObject('java', 'com.mongodb.BasicDBObject').init(o);
  return collection.update(obj, new_object, false, false);
    
} //end function



//swtich to or create database
function getDB(db_name){
   variables.db = mongo.getDb(db_name);
   this.db = mongo.getDb(db_name);
   db = mongo.getDb(db_name);	
   return db;
}


//switch to or create collection
function getCollection(collection_name){
  collection = db.getCollection(collection_name);
  return collection;
}

function collection(collection_name){
  collection = db.getCollection(collection_name);
  return this;
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


/*---------------------------------------------------------
        Expression Builder Wrappers
   ---------------------------------------------------------*/

function startsWith(element, val){
  expression_builder.startsWith(element, val);
  return this;
}

function endsWith(element, val){
  expression_builder.endsWith(element, val);
  return this;
}


function exists(element, val){
  var regex = '.*' & val & '.*';
  expression_builder.exists( element, regex );
  return this;
}

function regex(element, val){
  var regex = val;
  expression_builder.regex( element, regex );
  return this;
}

function where( js_expression ){
 expression_builder.where( js_expression );
 return this;
}

function inArray(element, val){
  expression_builder.inArray( element, val );
  return this;
}

 //vals should be list or array
function $in(element,vals){
  expression_builder.$in(element,vals);
  return this;
}

function $nin(element,vals){
  expression_builder.$in(element,vals);
  return this;
}


function $eq(element,val){
  expression_builder.$eq(element,val);
  return this;
}


function $ne(element,val){
  expression_builder.$ne(element,val);
  return this;
}


function $lt(element,val){
  expression_builder.$lt(element,val);
  return this;
  }


function $lte(element,val){
  expression_builder.$lte(element,val);
  return this;
}


function $gt(element,val){
  expression_builder.$gt(element,val);
  return this;
}


function $gte(element,val){
  expression_builder.$gte(element,val);
  return this;
}

function before(element,val){
  expression_builder.before(element,val);
  return this;
}

function after(element,val){
  expression_builder.after(element,val);
  return this;
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