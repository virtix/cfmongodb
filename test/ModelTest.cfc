<cfcomponent extends="BaseTest">
<!--- 
  In a single file, implement multiple models
 --->
<cfscript>


function testModel(){
mongo = createObject('component','cfmongodb.components.MongoDB').init('goodcoders');
mongo.getDb('goodcoders');

debug(mongo);
    developer = mongo.new_doc( 'developers' );
    developer.set('name','joe');
    skills = ['jquery','flex'];
    developer.set('skills', skills ); 
    developer.save();
    
    developer1 = mongo.new_doc( 'developers' );
    developer1.set('name','bill');
    skills1 = ['java','python','mongo'];
    developer1.set('skills', skills1 ); 
    developer1.save();
    
    proj_members = [ developer.get('_id'), developer1.get('_id') ];
    
    
    project =   mongo.new_doc( 'projects' );
    project.set('title', 'tops4tots');
    project.set('members',proj_members);
    project.save();
    
}

</cfscript>
</cfcomponent>