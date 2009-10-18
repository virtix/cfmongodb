<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
 friend = {
    name="f",
    email = 'f@f.org',
    address = {
      street = '123 f st',
      city = 'f',
      state = 'f',
      zip = '12345',
      country = 'usa'
    }  
  }; 
  
  person = {
    name="bill",
    email = 'bill@mxunit.org',
    address = {
      street = '123 main st',
      city = 'anytown',
      state = 'here',
      zip = '12345',
      country = 'usa'
    },
    friend=friend  
  };
  
  
function $endToEndSyntax(){
  mongo = createObject('component','Mongo');
  id = mongo.put(person); //name/value or struct
  id2 = mongo.put('asdasd','xcvxcvxc');
  the_guy = mongo.get('_id',id);
  debug(id.toString());
  debug(id2.toString());
  the = mongo.get('_id',id2);
  //debug(the);
  
  debug( mongo.count() );
  
  return;
  mongo.delete('NAME','bill');
  mongo.delete('asdasd','xcvxcvxc');
  debug( mongo.count() );
}
  


function $updatePerson(){
  mongo = createObject('component','Mongo');
  id = mongo.put(person); //name/value or struct
  person.name = 'ed';
  newperson = mongo.update(id,person);
  //debug(newperson.hashCode());
  debug(newperson);
  person._id = id.toString();
  debug(person);
  return;
  
  mongo.delete('NAME','bill');
  mongo.delete('NAME','ed');
  
}
  
  
  
  person ={
   name='bill',
   email='bill@bill.com'
  };
  
  
 function basicDbTest() {
   db = mongo.getDB("mydb");
   assertEquals("com.mongodb.DBTCP", db.getClass().getName() );
    
   coll = db.getCollection("testCollection");
   
   doc =  createObject('java', 'com.mongodb.BasicDBObject').init();
   doc.putAll(person);
   
   coll.insert(doc);
   
 }
  
  
  function smokeServerPort(){
    debug("these are defaults");
    assert( 'localhost'== mongo.getServer() );
    assert( '27017'== mongo.getPort() );
    assert( 'default_db'== mongo.getDBName() );
  }
   
  function mongoShouldBeCool() {
     assertSame(mongo, mongo);
     assertEquals(mongo, mongo);
     //debug(mongo);
  }
  

  
  function setUp(){
     mongo = createObject('component','MongoDB').init();
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
</cfcomponent>