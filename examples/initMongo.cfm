
<!--- pass 'false' in the URL to use the mongo jars in your cfusion lib directory --->
<cfparam name="url.useJavaLoader" default="true">


<cfparam name="variables.dbName" default="mongorocks">

<cfscript>
	if( url.useJavaLoader ){
		//the fastest way to try out cfmongodb is using Mark Mandel's javaloader, which we ship with cfmongodb. Thanks Mark!
		//http://javaloader.riaforge.org

		//use the cfmongodb javaloader factory
		javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init();

		//create a default MongoConfig instance; in your real apps, you'll create an object that extends MongoConfig and put your environment specific config in there
		//here we initialize it with a db named 'mongorocks'
		mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(dbName=variables.dbName, mongoFactory=javaloaderFactory);
	}
	else
	{
		mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(dbName=variables.dbName);
	}

	//initialize the core cfmongodb Mongo object
	mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig);

</cfscript>