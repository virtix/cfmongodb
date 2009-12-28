<cfcomponent extends="BaseTest">
<cfscript>
	
 mongo = createObject('component','cfmongodb.Mongo').init();
 
 
 
 function $setMongoInDocument(){
  doc = mongo.new_doc(collection_name='tester');
  doc.set('foo','bar');
  doc.save();
  
 }
 
 
 function $switchDb(){
  mongo.getDb('foo');
  doc = mongo.new_doc(collection_name='tester');
  doc.set('foo','bar');
  doc.save();
  
 }
 
 
 function insert_embedded_doc(){
   doc = mongo.new_doc(collection_name='test');
   doc.set('parent','dad');
   
   doc2 = mongo.new_doc(collection_name='test');
   doc2.set('child','son');
   doc2.save();
   
   child = {
    name='Jackson',
    age=7
   };
   
   doc.set('child', child);   
   id = doc.save();
   
   debug(id);
   
   mongo.collection('test');
   debug( mongo.findOne());
 	
 }
 
 function delete_doc_test(){
   doc = mongo.new_doc(collection_name='test');
   doc.set('foo','bar');
   id = doc.save();
   debug(id.toString());
   doc.delete(id);
   debug( doc.__props__ );
 //deleteById
 }	
 	
 function $set_should_set_doc_properties(){
   doc = mongo.new_doc(collection_name='test');
   doc.set('foo','bar');
   debug( doc.__props__ );
 }
 
 function $get_should_return_doc_properties(){
   doc = mongo.new_doc(collection_name='test');
   doc.set('foo','bar');
   assertEquals( 'bar', doc.get('foo') );
 }
 
 
 
 function $get_should_return_value_on_property(){
   doc = mongo.new_doc(collection_name='test');
   doc.set('foo','bar');
   doc.get('foo');
   assertEquals( 'bar', doc.get('foo') );
 }
 
 function $get_should_return_null_on_bad_property(){
   doc = mongo.new_doc(collection_name='test');
   doc.get('foo');
   assertEquals( chr(0), doc.get('foo') );
 }
 	
 	
 function dump_vars(){
   doc = mongo.new_doc(collection_name='test');
   doc.title = 'asdasd';
	doc.save();
 }
 	
 function mongo_should_return_doc(){
   doc = mongo.new_doc(collection_name='test');
   assertIsTypeOf( doc, 'cfmongodb.components.Document' );
 }
 
 

 

 function doc_save_should_save_to_mongo(){
   doc = '';
   doc = mongo.new_doc(collection_name='test');
   doc.set('title','the other title');
   tags = [1,2,3,4,5,6];
   doc.set('tags',tags);
   id = doc.save();
   debug(id.toString());
   
   //which collection do we want to deal with?
   //when should this be set?
   mongo.collection('test');
   debug( mongo.findOne());
     
 }
 	
 function smokeDoc(){
   doc = createObject('component','cfmongodb.components.Document');
   //debug( doc );
   debug( getComponentMetaData(doc) );
   debug( getMetaData(doc) );
   
   check(doc);
  //doc2 = createObject('component','SomeDoc');
   
 }
   
   

</cfscript>

<cffunction name="check" access="package">
  <cfargument name="o" type="cfmongodb.components.IDocument">
</cffunction>
</cfcomponent>