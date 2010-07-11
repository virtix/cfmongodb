<cfcomponent extends="mxunit.framework.TestCase">
<cfscript>
	
 mongo = createObject('component','cfmongodb.Mongo').init();
 
 
 
 function DocumentFactorySyntax(){
  doc = mongo.new_doc(collection_name='test_this');
  doc.set('foo','bar');
  doc.save();
  doc.delete();
  
 }
 

</cfscript>
</cfcomponent>