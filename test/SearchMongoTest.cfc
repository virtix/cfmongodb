<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
  //this would be a good data driven test! pass in an arbitrary list of integers
  function $TestTheLimits(){
    results = mongo.collection('blog').after( 'PUB_DATE', '01/01/1971' ).search('TITLE,TS,AUTHOR,PUB_DATE',1000);
    debug(results.toArray().size());
    assertEquals( 1000,results.toArray().size() );
    
    results = mongo.collection('blog').after( 'PUB_DATE', '01/01/1971' ).search('TITLE,TS,AUTHOR,PUB_DATE');
    debug(results.toArray().size());
    assertEquals( 1000,results.toArray().size() );
    
    results = mongo.collection('blog').after( 'PUB_DATE', '01/01/1971' ).search('TITLE,TS,AUTHOR,PUB_DATE',512);
    debug(results.toArray().size());
    assertEquals( 512,results.toArray().size() );
    
    results = mongo.collection('blog').after( 'PUB_DATE', '01/01/1971' ).search('TITLE,TS,AUTHOR,PUB_DATE',1);
    debug(results.toArray().size());
    assertEquals( 1,results.toArray().size() );
  }
  
  
  function $searchBeforeDateReturns0(){
    results = mongo.collection('blog').before( 'PUB_DATE', '01/01/1971' ).search('TITLE,TS,AUTHOR,PUB_DATE');
    debug(results.toArray().size());
    assertEquals( 0,results.toArray().size() );
  }
  
  function $searchAfterDateReturns1000(){
    results = mongo.collection('blog').after( 'PUB_DATE', '01/01/1971' ).search('TITLE,TS,AUTHOR,PUB_DATE',1000);
    debug(results.toArray().size());
    assertEquals( 1000,results.toArray().size() );
  }
  
  
  function searchINCRWithNE(){
    results = mongo.collection('blog').$ne( 'INCR', javacast('int',1) ).search('TITLE,TS,AUTHOR,PUB_DATE');
    assertEquals( 999,results.toArray().size() );
  }
  
  
  function searchINCRWithWhere(){
    results = mongo.collection('blog').where( "this.INCR == 1").search('TITLE,TS,AUTHOR,PUB_DATE');
    assertEquals( 1,results.toArray().size() );
	
	results = mongo.collection('blog').where( "this.INCR > 0 && this.INCR < 100").search('TITLE,TS,AUTHOR,PUB_DATE');
    assertEquals( 99,results.toArray().size() );
  }
  
   //1256242383663
   function searchTSWithWhere(){
    results = mongo.collection('blog').where( "this.TS > 1256242383663").search('TITLE,TS,AUTHOR,PUB_DATE');
    assertEquals( 1000,results.toArray().size() );
  }
  
  function searchTAGSWithWhere(){
    results = mongo.collection('blog').where( "this.TAGS == 'Java'").search('TITLE,TS,AUTHOR,PUB_DATE');
    assert( results.toArray().size() > 1 );
  }
  
  function searchTitleWithRegEx() {
    results = mongo.collection('blog').regex('TITLE','Blog Title No.6[0]{1,1}').search('TITLE,AUTHOR,PUB_DATE');
    debug( results.toArray().toString()  );
    assertEquals( 11,results.toArray().size() );
  }
  
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