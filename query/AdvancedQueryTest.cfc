<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
   
  function queryTest(){
    mongo = createObject('component','cfmongodb.MongoDB');
    mongo.switchCollection('mongoq');
	
	objects =  mongo.query('title:blog');
	
	
	
  
  }
  
 
  function setUp(){
  }
  
  function tearDown(){
  
  }    
 
 
</cfscript>



<!---
<cffunction name="genBlogPosts" access="private">
 <cfscript>
  var mongo = createObject('component','cfmongodb.MongoDB');
  var mongo.switchCollection('mongoq');
  var tags = ['food','technology','sports','religon'];
  var blog = '';
  var i = 1;
  
  for(i=1; i <= 100; i++){
    idx = randRange(1,arrayLen(tags));
	blog = {};
	blog.title = 'Blog Number #i#';
	blog.author = 'bill#i#';
	blog.text = 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Duis tellus. Donec ante dolor, iaculis nec, gravida ac, cursus in, eros. Mauris vestibulum, felis et egestas ullamcorper, purus nibh vehicula sem, eu egestas ante nisl non justo. Fusce tincidunt, lorem nec dapibus consectetuer, leo orci mollis ipsum, eget suscipit eros purus in ante. Wait, what am I saying? Never mind.';
    blog.tags = tags[idx];
	blog.pub_date = now();
	mongo.put(blog);
  }

 </cfscript>

</cffunction>
--->


</cfcomponent>