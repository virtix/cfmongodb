<!---
NOTE: a number of these unit tests run ensureIndex(). This is because Marc likes to run mongo with --notablescan during development, and queries
against unindexed fields will fail, thus throwing off the tests.

You should absolutely NOT run an ensureIndex on your columns every time you run a query!

 --->
<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
import cfmongodb.core.*;


	javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init();
	mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(dbName="cfmongodb_tests", mongoFactory=javaloaderFactory);
	//mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(dbName="cfmongodb_tests");


function setUp(){
	mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig);
	col = 'people';
	atomicCol = 'atomictests';
	deleteCol = 'deletetests';
	types = {
		'number' = 100,
		'negativefloat' = -987.097654,
		'positivefloat' = 9654.5555555,
		'israd' = true,
		'stringwithnum' = 'string ending with 1',
		'numbers' = [1,2,3],
		'booleans' = [true, false],
		'floats' = [1.3,2.59870,-148.27654]
	};
	doc = {
	    'name'='unittest',
	    'address' =  {
	       'street'='123 big top lane',
	       'city'='anytowne',
	       'state'='??',
	       'country'='USA'
	    },
	    'favorite-foods'=['popcicles','hot-dogs','ice-cream','cotton candy'],
		'types' = types
	  };
	structAppend( doc, types );
}
function tearDown(){
	var delete = {"name"="unittest"};
	var atomicDelete = {};
	mongo.remove( delete, col );

	mongo.close();

	//mongo.remove(atomicDelete, atomicCol);
}


function deleteTest(){
  mongo.getMongoDbCollection(deleteCol).drop();
  mongo.ensureIndex(["somenumber"], deleteCol);
  mongo.ensureIndex(["name"], deleteCol);
  var doc = {
    'name'='delete me',
	'somenumber' = 1,
    'address' =  {
       'street'='123 bye bye ln',
       'city'='where-ever',
       'state'='??',
       'country'='USA'
    }
  };

  doc['_id'] = mongo.save( doc, deleteCol );
  //debug(doc);

  results = mongo.query(deleteCol).$eq('somenumber',1).search();
  //debug(results.getQuery().toString());
  //debug(results.asArray());

  var writeResult = mongo.remove( doc, deleteCol );
  results = mongo.query(deleteCol).$eq('name','delete me').search();
  //debug(results.getQuery().toString());
  assertEquals( 0, results.size() );
}


function updateTest(){
  var originalCount = mongo.query(col).$eq('name', 'bill' ).count();
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


  //debug(results.getQuery().toString());

  replace_this = results.asArray()[1];
  debug(replace_this);
  replace_this['name'] = 'bill';
  mongo.update( replace_this, col );
  results = mongo.query(col).$eq('name', 'bill' ).search();
  debug(results.asArray());
  var finalSize = results.size();
  //debug(finalSize);
  var writeResult = mongo.remove( replace_this, col );

  assertEquals(originalCount+1, finalSize, "results should have been 1 but was #results.size()#" );
}


function testSearch(){
  var initial = mongo.query(col).startsWith('name','unittest').search().asArray();
  //debug(initial);

  var addNew = 5;
  var people = createPeople( addNew, true );
  var afterSave = mongo.query(col).startsWith('name','unittest').search().asArray();

  assertEquals( arrayLen(afterSave), arrayLen(initial) + addNew );
}

function distinct_should_return_array_of_distinct_values(){
	var collection = "distincts";
	var all = [
		{val=1},
		{val=1},
		{val=2},
		{val=1},
		{val=100}
	];
	mongo.remove({}, collection);
	var initial = mongo.distinct("VAL", collection);
	assertEquals(0,arrayLen(initial));

	mongo.saveAll( all, collection );
	var distincts = mongo.distinct("VAL", collection);
	assertEquals(1, distincts[1]);
	assertEquals(2, distincts[2]);
	assertEquals(100, distincts[3]);
}


function save_should_add_id_to_doc(){
  //debug(doc);
  id = mongo.save( doc, col );
  assert( NOT isSimpleValue(id) );
  mongo.remove( doc, col );
}

function saveAll_should_return_immediately_if_no_docs_present(){
	assertEquals( [], mongo.saveAll([],col)   );
}

function saveAll_should_save_ArrayOfDBObjects(){
	var i = 1;
	var people = [];
	var u = mongo.getMongoUtil();
	var purpose = "SaveAllDBObjectsTest";
	for( i = 1; i <= 2; i++ ){
		arrayAppend( people, u.toMongo( {"name"="unittest", "purpose"=purpose} ) );
	}
	mongo.saveAll( people, col );
	var result = mongo.query( col ).$eq("purpose",purpose).count();
	assertEquals(2,result,"We inserted 2 pre-created BasicDBObjects with purpose #purpose# but only found #result#");
}

function saveAll_should_save_ArrayOfStructs(){
	var i = 1;
	var people = [];
	var purpose = "SaveAllStructsTest";
	for( i = 1; i <= 2; i++ ){
		arrayAppend( people, {"name"="unittest", "purpose"=purpose} );
	}
	mongo.saveAll( people, col );
	var result = mongo.query( col ).$eq("purpose",purpose).count();
	assertEquals(2,result,"We inserted 2 structs with purpose #purpose# but only found #result#");
}

function findById_should_return_doc_for_id(){
	var id = mongo.save( doc, col );

	var fetched = mongo.findById(id.toString(), col);
	assertEquals(id, fetched._id.toString());
}

function search_sort_should_be_applied(){
	var people = createPeople(5, true);
	var asc = mongo.query(col).$eq("name","unittest").search();
	var desc = mongo.query(col).$eq("name","unittest").search(sort={"name"=-1});

	var ascResults = asc.asArray();
	var descResults = desc.asArray();
	//debug( desc.getQuery().toString() );

	//debug(ascResults);
	//debug(descResults);

	assertEquals( ascResults[1].age, descResults[ desc.size() ].age  );
}

function search_limit_should_be_applied(){
	var people = createPeople(5, true);
	var limit = 2;

	var full = mongo.query(col).$eq("name","unittest").search();
	var limited = mongo.query(col).$eq("name","unittest").search(limit=limit);
	assertEquals(limit, limited.size());
	assertTrue( full.size() GT limited.size() );
}

function search_skip_should_be_applied(){
	var people = createPeople(5, true);
	var skip = 1;
	var full = mongo.query(col).$eq("name","unittest").search();
	var skipped = mongo.query(col).$eq("name","unittest").search(skip=skip);

	assertEquals(full.asArray()[2] , skipped.asArray()[1], "lemme splain, Lucy: since we're skipping 1, then the first element of skipped should be the second element of full" );
}

function count_should_consider_query(){
	createPeople(2, true, "not unit test");

	mongo.ensureIndex(["nowaythiscolumnexists"], col);
	var allresults = mongo.query(col).search();
	//debug(allresults.size());
	var all = mongo.query(col).count();
	assertTrue( all GT 0 );

	var none = mongo.query(col).$eq("nowaythiscolumnexists", "I'm no tree... I am an Ent!").count();
	//debug(none);
	assertEquals( 0, none );

	var people = createPeople(2, true);

	var some = mongo.query(col).$eq("name", "unittest").count();
	all = mongo.query(col).count();
	assertTrue( some GTE 2 );
	assertTrue( some LT all, "Some [#some#] should have been less than all [#all#]");
}

private function createPeople( count=5, save="true", name="unittest" ){
	var i = 1;
	var people = [];
	for(i = 1; i LTE count; i++){
		var person = {
			"name"=name,
			"age"=randRange(10,100),
			"now"=getTickCount(),
			"counter"=i,
			inprocess=false
		};
		arrayAppend(people, person);
	}
	if(save){
		mongo.saveAll(people, col);
	}
	return people;
}

function findAndModify_should_atomically_update_and_return_new(){
	var collection = "atomictests";
	var count = 5;
	var people = createPeople(count=count, save="false");
	mongo.ensureIndex(["INPROCESS"], atomicCol);
	mongo.saveAll(people, atomicCol);

	flush();


	//get total inprocess count
	var inprocess = mongo.query(atomicCol).$eq("INPROCESS",false).search().size();


	//guard
	assertEquals(count, arrayLen(people));
	var query = {inprocess=false};
	var update = {inprocess=true, started=now(),owner=cgi.SERVER_NAME};
	var new = mongo.findAndModify(query=query, update=update, collectionName=atomicCol);
	flush();
	//debug(new);

	assertTrue( structKeyExists(new, "age") );
	assertTrue( structKeyExists(new, "name") );
	assertTrue( structKeyExists(new, "now") );
	assertTrue( structKeyExists(new, "started") );
	assertEquals( true, new.inprocess );
	assertEquals( cgi.SERVER_NAME, new.owner );


	var newinprocess = mongo.query(atomicCol).$eq("INPROCESS",false).search();
	//debug(newinprocess.getQuery().toString());

	assertEquals(inprocess-1, newinprocess.size());
}

function group_should_honor_optional_command_parameters(){
	var coll = "groups";
	mongo.remove({},coll);

	var groups = [
		{STATUS="P", ACTIVE=1, ADDED=now()},
		{STATUS="P", ACTIVE=1, ADDED=now()},
		{STATUS="P", ACTIVE=0, ADDED=now()},
		{STATUS="R", ACTIVE=1, ADDED=now()},
		{STATUS="R", ACTIVE=1, ADDED=now()}
	];
	mongo.saveAll( groups, coll );
	var groupResult = mongo.group( coll, "STATUS", {TOTAL=0}, "function(obj,agg){ agg.TOTAL++; }"  );
	//debug(groupResult);

	assertEquals( arrayLen(groups), groupResult[1].TOTAL + groupResult[2].TOTAL, "Without any query criteria, total number of results for status should match total number of documents in collection" );

	//add a criteria query
	groupResult = mongo.group( coll, "STATUS", {TOTAL=0}, "function(obj,agg){ agg.TOTAL++; }", {ACTIVE=1}  );
	assertEquals( arrayLen(groups)-1, groupResult[1].TOTAL + groupResult[2].TOTAL, "Looking at only ACTIVE=1 documents, total number of results for status should match total number of 'ACTIVE' documents in collection" );

	//add a finalize function
	groupResult = mongo.group( collectionName=coll, keys="STATUS", initial={TOTAL=0}, reduce="function(obj,agg){ agg.TOTAL++; }", finalize="function(out){ out.HI='mom'; }"  );
	assertTrue( structKeyExists(groupResult[1], "HI"), "output group should have contained the key added by finalize but did not" );

	//use the keyf function to create a composite key
	groupResult = mongo.group( collectionName=coll, keys="", initial={TOTAL=0}, reduce="function(obj,agg){ agg.TOTAL++; }", keyf="function(doc){ return {'TASK_STATUS' : doc.STATUS }; }"  );
	debug(groupResult);

	//TODO: get a better example of keyf
	assertTrue( structKeyExists(groupResult[1], "TASK_STATUS"), "Key should have been TASK_STATUS since we override the key in keyf function" );
}


function testGetIndexes(){
	var result = mongo.dropIndexes(collectionName=col);
	//guard
	assertEquals( 1, arrayLen(result), "always an index on _id" );

	mongo.ensureIndex( collectionName=col, fields=["name"]);
	mongo.ensureIndex( collectionName=col, fields=[{"name"=1},{"address.state"=-1}]);
	result = mongo.getIndexes( col );
	//debug(result);

	assertTrue( arrayLen(result) GT 1, "Should be at least 2: 1 for the _id, and one for the index we just added");
}

function testListCommandsViaMongoDriver(){
	var result = mongo.getMongoDB().command("listCommands");
	//debug(result);
	assertTrue( structKeyExists(result, "commands") );
	//NOTE: this is not a true CF struct, but a regular java hashmap; consequently, it is case sensitive!
	assertTrue( structCount(result["commands"]) GT 1);
}


/** test java getters */
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
	var jColl = mongo.getMongoDBCollection(col, mongoConfig);
	assertEquals("com.mongodb.DBApiLayer.mycollection",jColl.getClass().getCanonicalName());
}


/** dumping grounnd for proof of concept tests */

function poc_profiling(){
	var u = mongo.getMongoUtil();
	var command = u.toMongo({"profile"=2});
	var result = mongo.getMongoDB().command( command );
	//debug(result);

	var result = mongo.query("system.profile").search(limit=50,sort={"ts"=-1}).asArray();
	//debug(result);

	command = u.toMongo({"profile"=0});
	result = mongo.getMongoDB().command( command );
	//debug(result);
}

private function flush(){
	//forces mongo to flush
	mongo.getMongoDB().getLastError();
}

function newDBObject_should_be_acceptably_fast(){
	var i = 1;
	var count = 500;
	var u = mongo.getMongoUtil();
	var st = {string="string",number=1,float=1.5,date=now(),boolean=true};
	//get the first one out of its system
	var dbo = u.toMongo( st );
	var startTS = getTickCount();
	for(i=1; i LTE count; i++){
		dbo = u.toMongo( st );
	}
	var total = getTickCount() - startTS;
	assertTrue( total lt 200, "total should be acceptably fast but was #total#" );
}

function newDBObject_should_create_correct_datatypes(){
	var origNums = mongo.query( col ).$eq("number", types.number).count();
	var origNestedNums = mongo.query( col ).$eq("types.number", types.number).count();
	var origBool = mongo.query( col ).$eq("israd", true).count();
	var origNestedBool = mongo.query( col ).$eq("types.israd", true).count();
	var origFloats = mongo.query( col ).$eq("floats",1.3).count();
	var origNestedFloats = mongo.query( col ).$eq("types.floats",1.3).count();
	var origString = mongo.query( col ).$eq("address.street", "123 big top lane").count();

	mongo.save( doc, col );

	var newNums = mongo.query( col ).$eq("number", types.number).count();
	var newNestedNums = mongo.query( col ).$eq("types.number", types.number).count();
	var newBool = mongo.query( col ).$eq("israd", true).count();
	var newNestedBool = mongo.query( col ).$eq("types.israd", true).count();
	var newFloats = mongo.query( col ).$eq("floats",1.3).count();
	var newNestedFloats = mongo.query( col ).$eq("types.floats",1.3).count();
	var newString = mongo.query( col ).$eq("address.street", "123 big top lane").count();

	assertEquals( origNums+1, newNums );
	assertEquals( origNestedNums+1, newNestedNums );
	assertEquals( origBool+1, newBool );
	assertEquals( origNestedBool+1, newNestedBool );
	assertEquals( origFloats+1, newFloats );
	assertEquals( origNestedFloats+1, newNestedFloats );
	assertEquals( origString+1, newString );

}

/**
*	Confirm getLastError works and mongo has not changed it's response.
*/
function getLastError()
{
	var jColl = mongo.getMongoDBCollection(col, mongoConfig);
	var mongoUtil = mongo.getMongoUtil();

	// Create people to steal an id from
	createPeople();

	// Get the result of the last activity from CreatePeople()
	local.lastActivity = mongo.getLastError();

	// Verify the structure returned by Mongo has not changed
	var expected = listToArray('n,ok,err');
	local.actualKeys = structKeyArray(local.lastActivity);
	arraySort(local.actualKeys,'text');
	arraySort(expected,'text');
	assertEquals(
		 local.actualKeys
		,expected
		,'Mongo may have changed the getLastError() response.'
	);

	local.peeps = mongo.query(collectionName=col).search(limit="1").asArray();
	assertFalse(
		arrayIsEmpty(local.peeps)
		,'Some people should have been returned.'
	);


	// Let's duplicate the record.
	local.person = local.peeps[1];
	jColl.insert([mongoUtil.toMongo(local.person)]);

	// Get the result of the last activity
	local.lastActivity = mongo.getLastError();

	// Confirm we did try to duplicate an id.
	assert(
		 structKeyExists(local.lastActivity,'code')
		,'Mongo should be upset a record was duplicated. Check the test.'
	);

	// We now expect the error code to exist.
	var expected = listToArray('n,ok,err,code');
	local.actualKeys = structKeyArray(local.lastActivity);
	arraySort(local.actualKeys,'text');
	arraySort(expected,'text');
	assertEquals(
		 local.actualKeys
		,expected
		,'Mongo may have changed the getLastError() response.'
	);

	return;
}

 </cfscript>
</cfcomponent>

