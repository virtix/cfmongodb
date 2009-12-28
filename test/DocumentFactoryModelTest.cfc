<cfcomponent extends="BaseTest">
<cfscript>

model = createObject('component','fixture.MyMongoModel');

function new_person(){
  person = model.Person( 'bill', '123 main st' );   
  person.save();
  debug(person);  
}

function new_project(){
	var members = [ 1,2,3,4,5,6,7 ];
  var project = model.Project( 'Cool_101', members );   
  project.save();
   debug(project);    
}


</cfscript>
</cfcomponent>