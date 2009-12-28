<cfcomponent extends="BaseTest">
<cfscript>
	
model = createObject('component','fixture.MyMongoModel');
 

function new_project(){
  project = model.new_project( 'my project', 'owner=123' );   
  project.save();
} 
 
function new_person(){
  person = model.new_person( 'bill', '123 main st' );   
  person.save();  
}
 

</cfscript>
</cfcomponent>