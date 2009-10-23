<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
  function searchTitleContains() {
    results = mongo.collection('blog').exists('TITLE','Blog Title No.60').search('TITLE,AUTHOR,PUB_DATE');
    debug( results.toArray().toString()  );
    assertEquals( 11,results.toArray().size() );
  } 
   
  function searchTitleStartsWith() {
    results = mongo.collection('blog').startsWith('TITLE','Blog Title No.60').search('TITLE,AUTHOR,PUB_DATE');
    debug( results.toArray().toString()  );
    assertEquals( 11,results.toArray().size() );
  }

 function searchTitleEndsWith() {
    results = mongo.collection('blog').endsWith('TITLE','Blog Title No.60').search('TITLE,AUTHOR,PUB_DATE');
    debug( results.toArray().toString()  );
    assertEquals( 11,results.toArray().size() );
  }


  

  function testEmptyListToStruct(){
    list = '';  
    s = mongo.listToStruct(list);
    debug(s);
    assertEquals(0,s.size());  
  }


 function testListToStruct(){
    list = 'a,b,c,d,e,f,g';  
    s = mongo.listToStruct(list);
    debug(s);
    assertEquals(7,s.size());  
  }

  
  function setUp(){
    mongo = createObject('component','MongoDB');
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
</cfcomponent>