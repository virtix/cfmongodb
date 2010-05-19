<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
	//mongo = createObject('component','cfmongodb.test.fixture.').init();


   function testCFProps(){
      doc = createObject('component','cfmongodb.test.fixture.SomeCFCWithORMProperties');
      
      doc.name = 'mongo';
     
      //debug( doc.properties ); 
      debug( getMetadata(doc));
   }


 </cfscript>


</cfcomponent>