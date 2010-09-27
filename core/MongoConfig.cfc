<cfcomponent accessors="true" output="false" hint="Main configuration information for MongoDb connections. Defaults are provided, but should be changed as needed. ">

 <cfproperty name="environment" default="local">
<cfscript>
 
 variables.environment = "local";
 variables.conf = {"local" = {server_name = 'localhost', server_port = 27017}, db_name = 'default_db' };
 variables.conf.dev = variables.conf["local"];
 variables.conf.uat = variables.conf["local"];
 variables.conf.staging = variables.conf["local"];
 variables.conf.prod = variables.conf["local"];
 

 
 public struct function init(server_name='localhost',server_port='27017',db_name='default_db'){
 	establishHostInfo();
 	//initialize the defaults with incoming args
	structAppend( variables.conf["local"], arguments );
	
	//main entry point for environment-aware configuration
	environment = setUpEnvironment();
	
 	return this;
 }
 
  public void function establishHostInfo(){
	// environment decisions can often be made from this 
	var inetAddress = createObject( "java", "java.net.InetAddress");
	variables.hostAddress = inetAddress.getLocalHost().getHostAddress();
	variables.hostName = inetAddress.getLocalHost().getHostName();
  }
 
 /**
 * Main extension point: do whatever it takes to decide environment; set environment-specific defaults by overriding the environment-specific structure keyed on the environment name you decide
 */
 public string function setUpEnvironment(){
 	//overriding classes could do all manner of interesting things here... read config from properties file, etc.
 	return "local";
 }
 
 public string function getServerName(){ return getDefaults().server_name; }
 public string function getServerPort(){ return getDefaults().server_port; }
 public string function getDBName(){ return getDefaults().db_name; }
 
 public struct function getDefaults(){ return conf[environment]; }
 
 
</cfscript>
</cfcomponent>