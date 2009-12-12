<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>
	
 mongo = createObject('component','cfmongodb.Mongo').init();
 	
 function mongo_should_return_doc(){
   doc = mongo.new_doc(collection='blog');
   assertIsTypeOf( doc, 'cfmongodb.components.Document' );
 }
 
 function mongo_doc_should_add_properties(){
   doc = mongo.new_doc(collection='blog');
   doc.title = 'the title';
   debug(doc);
   assert( 'the title' == doc.title );
 }

 	
 function smokeDoc(){
   doc = createObject('component','cfmongodb.components.Document');
   //debug( doc );
   debug( getComponentMetaData(doc) );
   debug( getMetaData(doc) );
   
   check(doc);
   
   doc2 = createObject('component','SomeDoc');
   
 }

</cfscript>

<cffunction name="check" access="package">
  <cfargument name="o" type="cfmongodb.components.IDocument">
</cffunction>
</cfcomponent>