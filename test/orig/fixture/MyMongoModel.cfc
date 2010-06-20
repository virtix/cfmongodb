<cfcomponent  output="false">

<cfscript>
/* -------------------------------------------------
	Example of a "condensed" model.  Instead of separate
	files for each class, multiple "classes" can be 
	defined here using the mongo document factory.
----------------------------------------------------*/

mongo = createObject('component','cfmongodb.components.MongoDb');

function Person(name,addr){
   var person = mongo.new_doc( 'people' ); 
   person.set('name', name);
   person.set('address',addr);
   return person;
}

function Project(name,members){
   var project = mongo.new_doc( 'projects' ); 
   project.set('name', name);
   project.set('members',members);
   return project;
}
	
	
</cfscript>
</cfcomponent>