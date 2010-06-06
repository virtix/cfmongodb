<cfcomponent extends="BaseTestCase">

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">

<<<<<<< HEAD:test/MongoDBTest.cfc
    debug(items.count());
    debug(items.toArray().toString());
	assert(items.count() > 0);
    
  }
  
  
    function $findByRegEx(){
    coll = mongo.getCollection('blog');
    debug(coll.getName());
    p = createObject('java', 'java.util.regex.Pattern').compile('bill_6[0-2].*');
    exp = { AUTHOR=p };
    key_exp = {AUTHOR=1,TITLE=1,TS=1};
    keys = createObject('java', 'com.mongodb.BasicDBObject').init(key_exp);
    q = createObject('java', 'com.mongodb.BasicDBObject').init(exp);
    items = coll.find( q, keys );
    debug(items.count());
    debug(items.toArray().toString());
    
  }
 
 
  function genDataTest(){
    // uncomment next line to generate data :
	genBlogData() ;
  }
  
   
  function setUp(){
    // mongo = createObject('component','MongoDB');
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
=======
>>>>>>> 55e861e72919aa660874119e751de4e0fd3730b3:test/MongoDBTest.cfc

	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">

	</cffunction>

	<cffunction name="db_returns_cfmongodb_db">
		<cfset var db = mongo.db(dbName)>
		<cfset debug(db)>
		<cfset assertIsExactTypeOf(db,"cfmongodb.components.Database")>
	</cffunction>

	<cffunction name="collection_returns_cfmongodb_collection" output="false" access="public" returntype="any" hint="">
		<cfset var coll = mongo.collection(dbName,basicCollectionName)>
		<!---<cfset debug(coll)>--->
		<cfset assertIsExactTypeOf(coll,"cfmongodb.components.Collection")>
	</cffunction>


</cfcomponent>
