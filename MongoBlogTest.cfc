<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
    mongo = createObject('component', 'MongoDB');
    blog = createObject('component', 'Blog');
    

    blog.title = 'Title 1';
  	blog.text = 'Text 1';
  	blog.author = 'bill-1';
  	mongo.put(blog);
    
    blog.title = 'Title 2';
  	blog.text = 'Text 2';
  	blog.author = 'bill-2';
  	mongo.put(blog);
    
    blog.title = 'Title 3';
  	blog.text = 'Text 3';
  	blog.author = 'bill-3';
    mongo.put(blog);  
    
   /*  weird. setUp appears to not be called in Railo? */
  
  function _tearDown(){
    items = mongo.findAll();
    for(i=1; i<=arrayLen(items);i++){
      o = items[i];
      mongo.deleteById( o['_id'].toString() );
      debug( o['_id'].toString() );
    }
  }
   
   
  function testFindIterator(){
     items = mongo.findAll();
     assertEquals(3,items.size());
   }
   
  
  
  function setUp(){
  
  }

    
    
</cfscript>
</cfcomponent>