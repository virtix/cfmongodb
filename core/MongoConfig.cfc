<cfcomponent accessors="true" output="false" hint="Main configuration information for MongoDb connections. Defaults are provided, but should be overridden as needed in subclasses. ">

	<cfproperty name="environment" default="local">

	<cfscript>

	 variables.environment = "local";
	 variables.conf = {"local" = {server_name = 'localhost', server_port = 27017, db_name = 'default_db'}};
	 variables.conf.dev = variables.conf[environment];
	 variables.conf.uat = variables.conf[environment];
	 variables.conf.staging = variables.conf[environment];
	 variables.conf.prod = variables.conf[environment];



	 public struct function init(Array hosts = [{server_name='localhost',server_port='27017'}],db_name='default_db'){
	 	
	 	establishHostInfo();

	 	//initialize the defaults with incoming args
		structAppend( variables.conf[environment], arguments );

	 	if(not structKeyExists(variables.conf[environment],'servers')){
	 		variables.conf[environment].servers = createObject('java','java.util.ArrayList').init();
	 	}
	 	
	 	for(item in arguments.hosts){
	 		var sa = createObject( "java", "com.mongodb.ServerAddress").init(item.server_name,item.server_port);
	 		variables.conf[environment].servers.add(sa);
	 	}
	 	

		//main entry point for environment-aware configuration; subclasses should do their work in here
		environment = configureEnvironment();

	 	return this;
	 }

	  public void function establishHostInfo(){
		// environment decisions can often be made from this information
		var inetAddress = createObject( "java", "java.net.InetAddress");
		variables.hostAddress = inetAddress.getLocalHost().getHostAddress();
		variables.hostName = inetAddress.getLocalHost().getHostName();
	  }

	 /**
	 * Main extension point: do whatever it takes to decide environment;
	 * set environment-specific defaults by overriding the environment-specific
	 * structure keyed on the environment name you decide
	 */
	 public string function configureEnvironment(){
	 	//overriding classes could do all manner of interesting things here... read config from properties file, etc.
	 	return "local";
	 }

	 public string function getServerName(){ return getDefaults().server_name; }
	 public string function getServerPort(){ return getDefaults().server_port; }
	 public string function getDBName(){ return getDefaults().db_name; }
	 
	 public Array function getServers(){return getDefaults().servers; }

	 public struct function getDefaults(){ return conf[environment]; }


	</cfscript>
</cfcomponent>