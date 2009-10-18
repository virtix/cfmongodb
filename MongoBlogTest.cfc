<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
   mongo = createObject('component', 'MongoDB');
   
  function testBlog() {
    
     blog = createObject('component', 'Blog');
     blog.title = 'Look Ma. No SQL ...';
  	 blog.text = 'Rapid development with MongoDB';
  	 blog.author = 'bill';
     /*
     blog.author = 'billy';
     blog.title = 'blog test';
     blog.tags = ['politics','food','satire'];
     blog.body = '<h1>testing ...</h1>';
     blog.comments[1].author = 'Foo';
     blog.comments[1].comment_text = 'whatever';
     blog.comments[2].author = 'Bar';
     blog.comments[2].comment_www = 'http://google.com';
     blog.comments[2].comment_text = 'cool';
      */
        
     mongo.put(blog);
     
    // debug(blog);
         
    // blog.author = 'ed';
    // mongo.update(blog);
     
    // mongo.delete(blog);
    
    bb = mongo.findOne();
    debug(bb);
  }
  

    
    
</cfscript>
</cfcomponent>