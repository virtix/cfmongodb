<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
import cfmongodb.core.*;
mongo = createObject('component','cfmongodb.core.Mongo');
col = 'my_collection';
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
  
  doc['_id'] = mongo.save( doc,'my_collection' );
  debug(doc);
  mongo.remove( doc,'my_collection' );
  results = mongo.query('my_collection').$eq('name','delete me').search();
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
  mongo.update(replace_this,'my_collection');
  results = mongo.query('my_collection').$eq('name', 'bill' ).search().size();  
  mongo.remove( replace_this,'my_collection' );
  assert( results == 1 );
}



function testSearch(){
  results = mongo.query('my_collection').startsWith('name','joe').search();
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


 </cfscript>
</cfcomponent>