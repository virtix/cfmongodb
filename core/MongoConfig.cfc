<cfcomponent accessors="true" output="false" hint="Main configuration information for MongoDb connections. Defaults are provided, but should be overridden as needed in subclasses. ">

	<cfproperty name="environment" default="local">
	<cfproperty name="mongoFactory">

	<cfscript>

	variables.environment = "local";
	variables.conf = {};


	 /**
	 * Constructor
	 * @hosts Defaults to [{serverName='localhost',serverPort='27017'}]
	 */
	 public function init(Array hosts, dbName='default_db', MongoFactory="#createObject('DefaultFactory')#"){

	 	if (!structKeyExists(arguments, 'hosts') || arrayIsEmpty(arguments.hosts)) {
			arguments.hosts = [{serverName='localhost',serverPort='27017'}];
		}

		variables.mongoFactory = arguments.mongoFactory;
	 	establishHostInfo();

		variables.conf = { dbname = dbName, servers = mongoFactory.getObject('java.util.ArrayList').init(), auth={username="",password=""} };

		var item = "";
	 	for(item in arguments.hosts){
	 		addServer( item.serverName, item.serverPort );
	 	}

		//main entry point for environment-aware configuration; subclasses should do their work in here
		environment = configureEnvironment();

	 	return this;
	 }

	 public function addServer(serverName, serverPort){
	 	var sa = mongoFactory.getObject("com.mongodb.ServerAddress").init( serverName, serverPort );
	 	variables.conf.servers.add( sa );
		return this;
	 }

	 public function removeAllServers(){
	 	variables.conf.servers.clear();
	 	return this;
	 }

	 public function setAuthDetails(username, password) {
	 	structAppend(variables.conf.auth, arguments);
	 	return this;
	 }

	 public struct function getAuthDetails() {
	 	return variables.conf.auth;
	 }

	  public function establishHostInfo(){
		// environment decisions can often be made from this information
		var inetAddress = createObject( "java", "java.net.InetAddress");
		variables.hostAddress = inetAddress.getLocalHost().getHostAddress();
		variables.hostName = inetAddress.getLocalHost().getHostName();
		return this;
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

	 public struct function getDefaults(){ return conf; }



	</cfscript>
</cfcomponent>