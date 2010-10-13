<cfcomponent accessors="true" output="false" hint="Main configuration information for MongoDb connections. Defaults are provided, but should be overridden as needed in subclasses. ">

	<cfproperty name="environment" default="local">
	<cfproperty name="mongoFactory">

	<cfscript>

	 variables.environment = "local";
	 variables.conf = {"local" = {}};
	 variables.conf.dev = variables.conf[environment];
	 variables.conf.uat = variables.conf[environment];
	 variables.conf.staging = variables.conf[environment];
	 variables.conf.prod = variables.conf[environment];



	 public function init(Array hosts = [{serverName='localhost',serverPort='27017'}], dbName='default_db', MongoFactory="#createObject('DefaultFactory')#"){

		variables.mongoFactory = arguments.mongoFactory;
	 	establishHostInfo();

	 	//initialize the defaults with incoming args
		structAppend( variables.conf[environment], arguments );

	 	if(not structKeyExists(variables.conf[environment],'servers')){
	 		variables.conf[environment].servers = mongoFactory.getObject('java.util.ArrayList').init();
	 	}

		var item = "";
	 	for(item in arguments.hosts){
	 		addServer( environment, item.serverName, item.serverPort );
	 	}


		//main entry point for environment-aware configuration; subclasses should do their work in here
		environment = configureEnvironment();

	 	return this;
	 }

	 public function addServer(environment, serverName, serverPort){
	 	var sa = mongoFactory.getObject("com.mongodb.ServerAddress").init( serverName, serverPort );
	 	variables.conf[arguments.environment].servers.add( sa );
		return this;
	 }


	 public function removeAllServers(){
	 	variables.conf[environment].servers.clear();
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

	 public string function getDBName(){ return getDefaults().dbName; }

	 public Array function getServers(){return getDefaults().servers; }

	 public struct function getDefaults(){ return conf[environment]; }


	</cfscript>
</cfcomponent>