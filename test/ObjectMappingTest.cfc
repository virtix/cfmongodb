<cfcomponent extends="BaseTest" output="false">
<cfscript>
	
function dbRefTest(){
  mongo = createObject('component','cfmongodb.components.MongoDB');
  db = mongo.getDb('default_db');
   
  prog = mongo.new_doc('programmers');
  prog.set('name','bill');
  pid = prog.save();
  
  prog2 = mongo.new_doc('programmers');
  prog2.set('name','pete');
  pid2 = prog2.save();
  
  ref1 = mongo.dbRef('programmers', pid);
  ref2 = mongo.dbRef('programmers', pid2);
  
  refs = [ ref1, ref2 ];

  proj = mongo.new_doc('projects');
  proj.set('foo','bar');
  proj.set('programers', refs);
  
  id = proj.save();
  debug(prog); 
 // debug(proj); 
  
  progz = proj.get('programers'); //getDbRef() ???
  bill =  progz[1].fetch();
  debug(bill);
  
  assertEquals( 'bill' , bill.get('name') );
  
  bill =  progz[1].fetch();
  assertEquals( 'bill' , bill.get('name'));
  
  proj.delete();
  prog.delete();
  
}
	
function testCreatePersonModel(){
  var person = createObject( 'component','fixture.PersonModel');
  person.foo = 'bar';
  person.model.foo = 'barbar';
  person.set('name','bill');
  colors = ['red','green','blue'];
  person.set('email','bill@bill.com');
  person.set('street','123 main street');
  person.set('city','anytown');
  person.set('state','VA');
  person.set('zip','12345');
  person.set('colors', colors);
  person.save();
  
  //debug( getComponentMetaData('fixture.PersonModel') );
  
  person.set('name','john');
  person.update();
  
  debug( person.model );
  
  //no side effects
  //person.delete();
  
}

</cfscript>
</cfcomponent>