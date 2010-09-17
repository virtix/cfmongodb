
<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
import cfmongodb.core.*;

function setUp(){
	mongoConfig = createObject('component','cfmongodb.core.MongoConfig');
	mongoConfig.setDefaults(db_name="cfmongodb_tests");
	javaloader = createObject('component','javaloader.javaloader').init([ expandPath("/cfmongodb/lib/mongo-2.1.jar") ]);
	javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init(javaloader);
	mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig, javaloaderFactory);

	col = 'people';

	doc = {
	    'name'='joe-joe',
	    'address' =  {
	       'street'='123 big top lane',
	       'city'='anytowne',
	       'state'='??',
	       'country'='USA'
	    },
	    'favorite-foods'=['popcicles','hot-dogs','ice-cream','cotton candy']
	  };
}



function deleteTest(){
  var doc = {
    'name'='delete me',
    'address' =  {
       'street'='123 bye bye ln',
       'city'='where-ever',
       'state'='??',
       'country'='USA'
    }
  };

  doc['_id'] = mongo.save( doc, col );
  debug(doc);

  mongo.remove( doc, col );
  results = mongo.query(col).$eq('name','delete me').search();
  //debug(results);
  assertEquals( 0, results.size() );
}



function updateTest(){

  var doc = {
    'name'='jabber-walkie',
    'address' =  {
       'street'='456 boom boom',
       'city'='anytowne',
       'state'='??',
       'country'='USA'
    },
    'favorite-foods'=['munchies']
  };
  mongo.save(doc,col);
  results = mongo.query(col).startsWith('name','jabber').search();

  //debug(results.getQuery());


  replace_this = results.asArray()[1];
  replace_this['name'] = 'bill';
  mongo.update( replace_this, col );
  results = mongo.query(col).$eq('name', 'bill' ).search().size();
  mongo.remove( replace_this, col );
  assert( results == 1, "results should have been 1 but was #results#" );
}



function testSearch(){
  results = mongo.query(col).startsWith('name','joe').search();
  debug(results.asArray());
}



function testStoreDoc(){
  debug(doc);
  id = mongo.save( doc, col );
  assert( id is not '' );
  mongo.remove( doc, col );
}

function testGetIndexes(){
	var result = mongo.dropIndexes(coll=col);
	//guard
	assertEquals( 1, arrayLen(result), "always an index on _id" );

	mongo.ensureIndex( coll=col, fields=["name"]);
	mongo.ensureIndex( coll=col, fields=[{"name"=1},{"address.state"=-1}]);
	result = mongo.getIndexes( col );
	debug(result);

	assertTrue( arrayLen(result) GT 1, "Should be at least 2: 1 for the _id, and one for the index we just added");
}

function testListCommandsViaMongoDriver(){
	var result = mongo.getMongoDB().command("listCommands");
	//debug(result);
	assertTrue( structKeyExists(result, "commands") );
	//NOTE: this is not a true CF struct, but a regular java hashmap; consequently, it is case sensitive!
	assertTrue( structCount(result["commands"]) GT 1);
}


function testGetMongo(){
  assertIsTypeOf( mongo, "cfmongodb.core.Mongo" );
}

function getMongo_should_return_underlying_java_Mongo(){
	var jMongo = mongo.getMongo();
	assertEquals("com.mongodb.Mongo",jMongo.getClass().getCanonicalName());
}

function getMongoDB_should_return_underlying_java_MongoDB(){

	var jMongoDB = mongo.getMongoDB(mongoConfig);
	assertEquals("com.mongodb.DBApiLayer",jMongoDB.getClass().getCanonicalName());
}

function getMongoDBCollection_should_return_underlying_java_DBCollection(){
	var jColl = mongo.getMongoDBCollection(mongoConfig,col);
	assertEquals("com.mongodb.DBApiLayer.mycollection",jColl.getClass().getCanonicalName());
}


function cheapJavaloaderBenchmark(){
	var i = 1;
	var startTS = getTickCount();
	var jdbo = "";
	var dbo = "";

	for(i=1; i LTE 100; i++){
		jdbo = javaloaderFactory.getObject("com.mongodb.BasicDBObject");
	}
	var total = getTickCount() - startTS;
	debug("javaloader total: #total#");

	var defaultFactory = createObject("cfmongodb.core.DefaultFactory");

	startTS = getTickCount();
	for(i=1; i LTE 100; i++){
		dbo = defaultFactory.getObject("com.mongodb.BasicDBObject");
	}
	var total = getTickCount() - startTS;
	debug("default total: #total#");

	//clone the last javaloader dbo
	startTS = getTickCount();
	for(i=1; i LTE 100; i++){
		jdboc = jdbo.clone();
	}
	var total = getTickCount() - startTS;
	debug("jdbo clone total: #total#");

	//clone the last cf dbo
	startTS = getTickCount();
	for(i=1; i LTE 100; i++){
		jdboc = dbo.clone();
	}
	var total = getTickCount() - startTS;
	debug("dbo clone total: #total#");

	debug(getMetadata(jdbo));
	debug(getMetadata(dbo));

	var dmethods = jdbo.getClass().getMethods();
	//debug(dmethods);
	var allMethods = {};
	for(i = 1; i LTE arrayLen(dmethods); i++){
		allMethods[dMethods[i].getName()] = true;
	}

	debug(allMethods);

}

 </cfscript>
</cfcomponent>

