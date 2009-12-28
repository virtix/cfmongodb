<cfcomponent extends="BaseTest">
<cfscript>
	
 mongo = createObject('component','cfmongodb.Mongo').init();
 
 
 
 function newDoc(){
   doc = createObject('component','fixture.MyMongoDocument').init('my_mongo');
   doc.set('title','my title');
   doc.save();
  
 }
 

</cfscript>
</cfcomponent>