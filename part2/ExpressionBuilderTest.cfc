<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>
 mongo = createObject('component','MongoDB');
 coll = mongo.getCollection('blog');
 key_exp = {AUTHOR=1,TITLE=1,TS=1};
 keys = createObject('java', 'com.mongodb.BasicDBObject').init(key_exp);



function $testFluentChain(){
 criteria = builder.start().
             		inArray( 'TAGS', 'Java' ).
             		$nin( 'AUTHOR', ['bill_1','bill_202','bill_101','bill_999','bogus_bill','bill_506'] ).
             		exists('BODY' , 'orci').
             		get();

 q = createObject('java', 'com.mongodb.BasicDBObject').init(criteria);
 debug(q);
 items = coll.find(q,keys);
  debug(items.count());
  debug(items.toArray().toString());
}


function $testWhereJSExpression(){
  builder.start();
  temp = builder.where( "this.TAGS == 'Java'");
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find(q,keys);
  ia = items.toArray(); 
  debug(items.count());
  debug(items.toArray().toString());
  assertEquals( 7, items.count() );
}



//array tests: search tags:
function $testInArray(){
  builder.start();
  temp = builder.inArray( 'TAGS', 'Java' );
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find(q,keys);
  ia = items.toArray(); 
  debug(items.count());
  debug(items.toArray().toString());
  assertEquals( 69	 , items.count() );
}


function testNIN(){
  builder.start();
  temp = builder.$nin( 'AUTHOR', ['bill_1','bill_202','bill_101','bill_999','bogus_bill'] );
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find(q,keys);
  ia = items.toArray(); 
  debug(items.count());
  //debug(items.toArray().toString());
  assertEquals( 996	 , items.count() );
}


function testNINWithStringList(){
  builder.start();
  temp = builder.$nin( 'AUTHOR', 'bill_1,bill_202,bill_101,bill_999,bogus_bill' );
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find(q,keys);
  ia = items.toArray(); 
  debug(items.count());
  //debug(items.toArray().toString());
  assertEquals( 996 , items.count() );
  
}


function testInWithStringList(){
  builder.start();
  temp = builder.$in( 'AUTHOR', 'bill_1,bill_202,bill_101,bill_999,bogus_bill' );
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find(q,keys);
  ia = items.toArray(); 
  debug(items.count());
  //debug(items.toArray().toString());
  assertEquals( 4	 , items.count() );
  
}

function testIn(){
  builder.start();
  temp = builder.$in( 'AUTHOR', ['bill_1','bill_202','bill_101','bill_999','bogus_bill'] );
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find(q,keys);
  ia = items.toArray(); 
  debug(items.count());
  //debug(items.toArray().toString());
  assertEquals( 4	 , items.count() );
}


function testEQ(){
  builder.start();
  temp = builder.$eq( 'TS', 1256174339614); //not good test - volitile
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find(q,keys);
  ia = items.toArray(); 
  debug(items.count());
  //debug(items.toArray().toString());
  assertEquals( 1	 , items.count() );
}



function testNEQ(){
  builder.start();
  temp = builder.$ne( 'TS', -9);
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find(q,keys);
  ia = items.toArray(); 
  debug(items.count());
  //debug(items.toArray().toString());
  assertEquals( 1000 , items.count() );
}


function testLTE(){
  builder.start();
  temp = builder.$lte( 'TS', 9999999999999999999999);
  debug(builder.get());
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find( q, keys );
  ia = items.toArray(); 
  debug(items.count());
  //debug(items.toArray().toString());
  assertEquals( 1000 , items.count() );
}


function testLT(){
  builder.start();
  temp = builder.$lt( 'TS', 9999999999999999999999);
  debug(builder.get());
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find( q, keys );
  ia = items.toArray(); 
  debug(items.count());
  //debug(items.toArray().toString());
  assertEquals( 1000 , items.count() );
}


function testGT(){
  builder.start();
  temp = builder.$gt( 'TS', 0);
  debug(builder.get());
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find( q, keys );
  ia = items.toArray(); 
  debug(items.count());
  //debug(items.toArray().toString());
  assertEquals( 1000 , items.count() );
}


function testGTE(){
  builder.start();
  temp = builder.$gte( 'TS', 0);
  debug(builder.get());
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  debug(q);
  items = coll.find( q, keys );
  ia = items.toArray(); 
  debug(items.count());
  //debug(items.toArray().toString());
  assertEquals( 1000 , items.count() );
}



function testRegEx(){
  temp = builder.regex( 'TITLE', '.*No.600$');
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  items = coll.find( q, keys );
  ia = items.toArray(); 
  debug(items.count());
  debug(items.toArray().toString());
  debug(items.toArray());
  assert( ia.size() );
  assertEquals( ia[1]["TITLE"], "Blog Title No.600" );
  assertEquals( ia[1]["AUTHOR"], "bill_600" );
}


function testExists(){
  temp = builder.exists( 'TITLE', 'Title No.600');
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  items = coll.find( q, keys );
  ia = items.toArray(); 
  debug(items.count());
  debug(items.toArray().toString());
  debug(items.toArray());
  assertEquals( ia[1]["TITLE"], "Blog Title No.600" );
  assertEquals( ia[1]["AUTHOR"], "bill_600" );
}


function testStartsWith(){
  temp = builder.startsWith( 'AUTHOR', 'bill_60');
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  items = coll.find( q, keys );
  debug(items.count());
  debug(items.toArray().toString());
  assertEquals( 11, items.count() );
}

function testEndsWith(){
  temp = builder.endsWith( 'TITLE', 'Title No.609');
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  items = coll.find( q, keys );
  debug(items.count());
  debug(items.toArray().toString());
  assertEquals( 1, items.count() );
}

function setUp(){
  builder = createObject('component','ExpressionBuilder');
}


</cfscript>
</cfcomponent>