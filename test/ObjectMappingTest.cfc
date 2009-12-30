<cfcomponent extends="BaseTest" output="false">
<cfscript>
	
function dbRefTest(){
  mongo = createObject('component','cfmongodb.components.MongoDB');

  db = mongo.getDb('default_db');

    
  prog = mongo.new_doc('programmers');
 //  //should be in mongo wrapper!
  prog.set('name','bill');
  pid = prog.save();
  
  prog2 = mongo.new_doc('programmers');
 //  //should be in mongo wrapper!
  prog2.set('name','pete');
  pid2 = prog2.save();
  
  //ref = createObject('java','com.mongodb.DBRef').init( db, 'programmers', pid);
  ref1 = mongo.dbRef('programmers', pid);
  ref2 = mongo.dbRef('programmers', pid2);
  refs = [ ref1, ref2 ];

  proj = mongo.new_doc('projects');
  proj.set('foo','bar');
  proj.set('programers', refs);
  
  id = proj.save();
  debug(id); 
  debug(proj); 
  
  progz = proj.get('programers');
  debug(progz[1].fetch());
  
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