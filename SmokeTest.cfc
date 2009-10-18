<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
   mongo = createObject('java', 'com.mongodb.Mongo').init( "localhost" , 27017 );
     //debug(mongo);
     db = mongo.getDB( "mydb" );
     a = [1,2,3,4,5,['x','y','z'],{bar=123.098}];
     a2 = [1,2,3,4];
     
     o = {
       user='bill',
       foo='bar',
       a=a
     };
     
     
     person = {
       name="bill",
       email="billshelton@comcast.net",
       address="123 Main St, Anytown, USA"
     };
     
     
   function listTest() {
     list_doc =  createObject('java', 'com.mongodb.BasicDBList').init();
     debug(list_doc);
     fail("can't seem to add to basicdb list");
     id = list_doc.add(1);
     coll = db.getCollection("testCollection");
     coll.insert(list_doc);
     
    }  
     
   function serializeTest() {
      
   // debug(a);   
    //  writeoutput(serializeJSON(a));   
     writeoutput(serializeJSON(person));
     jdoc =  createObject('java', 'com.mongodb.BasicDBObject').init();
    // debug(jdoc);
     jdoc.putAll(person);
    
    
     //jdoc.putAll(serializeJSON(o));
     //debug(jdoc);
     debug(db.getCollectionNames().toString());
     
     coll = db.getCollection("testCollection");
     q = createObject('java', 'com.mongodb.BasicDBObject').init('NAME','bill');
     
     //debug(coll);
    // coll.remove(q);
    // coll.insert(jdoc);
     
    // theDoc = coll.findOne();
    // debug(theDoc);
    
    
    
    cur = coll.find(q);
    debug(cur.toArray());
    debug( jdoc.keySet().toArray() );
     
     }
   
  function testMongoIsLoaded() {
    
     //debug(db);
     coll = db.getCollection("testCollection");
     debug(coll.toString());
     doc =  createObject('java', 'com.mongodb.BasicDBObject').init();
     
     doc.put("name", "MongoDB");
     doc.put("type", "database");
     doc.put("count", 1);
     
     debug(doc);
     
     
     coll.insert(doc);
     
     theDoc = coll.findOne();
     debug(theDoc);
     
     
     //colls = db.getCollectionNames();
     //debug(colls);
     
  }
  

  
  function setUp(){
  
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
</cfcomponent>