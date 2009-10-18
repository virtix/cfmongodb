<cfcomponent output="false">
<cfscript>
variables.server_name = 'localhost';
variables.server_port = 27017;	
variables.mongo = chr(0);
variables.db_name = "default_db";
variables.collection_name = "default_collection";
	
/********************************
  mongo = createObject('java', 'com.mongodb.Mongo').init( "localhost" , 27017 );
  //debug(mongo);
  db = mongo.getDB( "mydb" );

************************************/	
	
	
function init(){
  if( arguments.size() gte 1 ) setServer(arguments[1]);
  if( arguments.size() gte 2  ) setPort(arguments[2]);
  if( arguments.size() gte 3  ) setDatabase(arguments[3]);
  variables.mongo = createObject('java', 'com.mongodb.Mongo').init( getServer() , getPort() );
  variables.db_name = getDBName();
  return this;
}


function getDb() {
  if( arguments.size() ) {
    return variables.mongo.getDB( arguments[1] );
  }
  else{
    return variables.mongo.getDB( variables.db_name ); //default name
  }
}




/*********************************************
	          acessor methods
***********************************************/
function setCollection(collection_name) {
  variables.collection_name =  arguments.collection_name;
}

function getCollection() {
  return variables.collection_name;
}

function getDBName(){
  return variables.db_name;
}

function setDBName(db_name){
  variables.db_name = arguments.db_name;
}

function setServer(server_name){
  variables.server_name = arguments.server_name;
}

function setPort(port){
  variables.server_port = port;
}


function getPort(){
 return variables.server_port;
}
function getServer(){
 return variables.server_name;
}

</cfscript>
</cfcomponent>