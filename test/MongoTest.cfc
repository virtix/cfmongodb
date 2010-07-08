
<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
import cfmongodb.core.*;

function setUp(){
	mongoConfig = createObject('component','cfmongodb.core.MongoConfig');
	mongoConfig.setDefaults(db_name="cfmongodb_tests");
	mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig);
	
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
  debug(results);
  assertEquals( 0, arrayLen(results) );
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
  replace_this = results[1];
  replace_this['name'] = 'bill';
  mongo.update(replace_this,col);
  results = mongo.query(col).$eq('name', 'bill' ).search().size();
  mongo.remove( replace_this,col );
  assert( results == 1, "results should have been 1 but was #results#" );
}



function testSearch(){
  results = mongo.query(col).startsWith('name','joe').search();
  debug(results);
}



function testStoreDoc(){
  debug(doc);
  id = mongo.save( doc, col );
  assert( id is not '' );
  mongo.remove( doc, col );
}


function testGetMongo(){
  mongo = new Mongo();
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

 </cfscript>
</cfcomponent>

