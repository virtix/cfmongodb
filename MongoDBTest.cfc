<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
  
 function mongoShouldConnect() {
  
 }
  
  
  function smokeServerPort(){
    debug("these are defaults");
    assert( 'localhost'== mongo.getServer() );
    assert( '27017'== mongo.getPort() );
  }
   
  function mongoShouldBeCool() {
     assertSame(mongo, mongo);
     assertEquals(mongo, mongo);
     //debug(mongo);
  }
  

  
  function setUp(){
     mongo = createObject('component','MongoDB').init();
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
</cfcomponent>