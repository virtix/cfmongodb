<cfcomponent output="false">
<!--- 
Operations on Databases:

set port
set server

 --->
<cfscript>
//This maybe should be a config object
config = {
  server_name = 'localhost',
  server_port = 27017,
  db_name = 'default_db',
 };
 
 mongo = createObject('java', 'com.mongodb.Mongo').init( variables.config.server_name , variables.config.server_port );
 
 function getDB(name){
   return mongo.getDB(name);
 }
</cfscript>

<!--- 

getAddress	public com.mongodb.DBAddress com.mongodb.DBTCP.getAddress()
debugString	public java.lang.String com.mongodb.DBTCP.debugString()
requestStart	public void com.mongodb.DBTCP.requestStart()
requestDone	public void com.mongodb.DBTCP.requestDone()
requestEnsureConnection	public void com.mongodb.DBTCP.requestEnsureConnection()
getConnectPoint	public java.lang.String com.mongodb.DBTCP.getConnectPoint()
getCollectionFromFull	public com.mongodb.DBApiLayer$MyCollection com.mongodb.DBApiLayer.getCollectionFromFull(java.lang.String)
getCollectionFromFull	public com.mongodb.DBCollection com.mongodb.DBApiLayer.getCollectionFromFull(java.lang.String)
getCollectionNames	public java.util.Set com.mongodb.DBApiLayer.getCollectionNames() throws com.mongodb.MongoException
toString	public java.lang.String com.mongodb.DB.toString()
getName	public java.lang.String com.mongodb.DB.getName()
setReadOnly	public void com.mongodb.DB.setReadOnly(java.lang.Boolean)
command	public com.mongodb.DBObject com.mongodb.DB.command(com.mongodb.DBObject) throws com.mongodb.MongoException
eval	public java.lang.Object com.mongodb.DB.eval(java.lang.String,java.lang.Object[]) throws com.mongodb.MongoException
authenticate	public boolean com.mongodb.DB.authenticate(java.lang.String,char[]) throws com.mongodb.MongoException
getCollection	public final com.mongodb.DBCollection com.mongodb.DB.getCollection(java.lang.String)
createCollection	public final com.mongodb.DBCollection com.mongodb.DB.createCollection(java.lang.String,com.mongodb.DBObject)
dropDatabase	public void com.mongodb.DB.dropDatabase() throws com.mongodb.MongoException
getCollectionFromString	public com.mongodb.DBCollection com.mongodb.DB.getCollectionFromString(java.lang.String)
doEval	public com.mongodb.DBObject com.mongodb.DB.doEval(java.lang.String,java.lang.Object[]) throws com.mongodb.MongoException
resetIndexCache	public void com.mongodb.DB.resetIndexCache()
getLastError	public com.mongodb.DBObject com.mongodb.DB.getLastError() throws com.mongodb.MongoException
setWriteConcern	public void com.mongodb.DB.setWriteConcern(com.mongodb.DB$WriteConcern)
getWriteConcern	public com.mongodb.DB$WriteConcern com.mongodb.DB.getWriteConcern()
addUser	public void com.mongodb.DB.addUser(java.lang.String,char[])
getPreviousError	public com.mongodb.DBObject com.mongodb.DB.getPreviousError() throws com.mongodb.MongoException
resetError	public void com.mongodb.DB.resetError() throws com.mongodb.MongoException
forceError	public void com.mongodb.DB.forceError() throws com.mongodb.MongoException
 --->

</cfcomponent>