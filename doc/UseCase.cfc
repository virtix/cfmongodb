<cfcomponent output="false">
<cfscript>
/*-------------------------------------------------------------------------------------

  Create document
     meta data to include strings and dates
     child objects to include other documents and binary data such as images, mp3, video
  Update Document
  Fetch Document
  Delete Document
  
  Search Collection
  Query Database for info about collections ( how many documents )
  Current database
  Current collection
  Port
  Server
  
  List of Collection names in DB
  List of Indexes in Collection
  Number of Documents in Collection
  
  
  
  
-------------------------------------------------------------------------------------*/

 //make sure there's potential for dependency injection for testing

 doc = mongo.new_doc(collection='blog');
 doc.title = 'asd';
 doc.body = 'asd';
 doc.tags = ['java','python'];
 doc.mp3 = [binary];
 doc.ensureIndex( list='title,id' );
 id = doc.save(); //create new ... ot create new OR update all
 
 doc = mongo.fetch(id);
 doc.update( 'body' , 'new value' ); //done
  OR
 doc.body = 'new value'
 doc.update(); //can it know what to update and do it intelligently? or could doc.update(); update everything vs. in place?
 

Another option would be to implement IMongoDocument instead of using mongo.new_document():

doc = new MyDocument(); //implements IMongoDocument or inherits from MongoDocument which implements IMongoDocument
doc.title = 'asd';
doc.body = 'asd';
... 
doc.ensureIndex( list='title,id' );
id = doc.save(); //interface



 //Updates

 doc = mongo.collection('blog').$eq('id', '123456789').fetch(); //get's one
 //update comments
 doc.push('array_item', value);
 doc.update('title','new title');


 results = mongo.collection('blog').startsWith('name','foo').
                                       endsWith('title','bar').
                                       exists('field','value').
                                       regex('field','value').
                                       before('field', 'value').search( limit=100 );


 for( item in results ){
   mongo.print( item.title );
 }

</cfscript>
</cfcomponent>