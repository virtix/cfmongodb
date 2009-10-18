<cfcomponent output="false">
<cfscript>
variables.server_name = 'localhost';
variables.server_port = 27017;	
variables.mongo = chr(0);
variables.db_name = "default_db";
	
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
  variables.db_name = getDatabase();
  return this;
}


function getDatabase(){
  return variables.db_name;
}

function setDatabase(db_name){
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