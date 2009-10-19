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
  

function testSerializeJSONThis(){
  var p = createObject('component','Blog');
  var j = serializeJSON(p);
  debug(j);
  mongo = createObject('component','MongoDB');
  id = mongo.put(p);
  o = mongo.get('_id',id);
  debug(o);
  mongo.delete(p);
}  
  
function $endToEndSyntax(){
  mongo = createObject('component','MongoDB');
  id = mongo.put(person); //name/value or struct
  the_guy = mongo.get('_id',id);
  debug(id.toString());
  debug( mongo.count() );
  assert(1==mongo.count());
  mongo.delete(person);
  
}
  
function $testFindSame(){
 return;
  mongo = createObject('component','MongoDB');
  //id = mongo.put(person); //name/value or struct
  person.name = 'ed';
  newperson = mongo.findSame(person);
  debug(person);
  debug(newperson);
  mongo.delete(person);
  assertEquals(newperson.name,'ed');
}

function $updatePerson(){
  mongo = createObject('component','MongoDB');
  mongo.put(person); //name/value or struct
  person.name = 'ed';
  newperson = mongo.update(person);
  //debug(newperson.hashCode());
  debug(newperson);
   
  mongo.delete(person);
  
  
}
  
  
  
  person ={
   name='bill',
   email='bill@bill.com'
  };
  
  function getByStringIdTest(){
   var localp ={
   		name='shmoopy',
   		email='shmoopy@bshmoopy.com'
  		};
    var id = mongo.put(localp);
    var fetched_from_db_person = mongo.getById( id.toString() );
    debug(fetched_from_db_person);
    mongo.deleteById(id.toString());
    assertEquals(fetched_from_db_person.name,'shmoopy');
    
  }
  
   
  function setUp(){
     mongo = createObject('component','MongoDB');
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
</cfcomponent>