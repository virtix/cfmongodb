<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>
 mongo = createObject('component','MongoDB');
 coll = mongo.getCollection('blog');
 key_exp = {AUTHOR=1,TITLE=1,TS=1};
 keys = createObject('java', 'com.mongodb.BasicDBObject').init(key_exp);


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


function testGT(){
  temp = builder.$gt( 'TS', 1256148921000);
  q = createObject('java', 'com.mongodb.BasicDBObject').init(builder.get());
  items = coll.find( q, keys );
  ia = items.toArray(); 
  debug(items.count());
  debug(items.toArray().toString());
  fail( 'last test of the day. must.go.home.' );
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