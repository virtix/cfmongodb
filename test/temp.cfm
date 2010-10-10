<cfscript>



	javaPaths = directoryList( expandPath("/cfmongodb/lib"), false, "path", "*.jar" );
	binPath = expandPath("/cfmongodb/java/bin/");
	arrayappend(javaPaths, binPath);
	javaloader = createObject('component','cfmongodb.lib.javaloader.javaloader').init(javaPaths);
	javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init(javaloader);
	mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(db_name="cfmongodb_tests");
	mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig, javaloaderFactory);


	i = 1;
	count = 100;
	u = mongo.getMongoUtil();
	st = {string="string",number=1,float=1.5,date=now(),boolean=true};
	startTS = getTickCount();
	for(i=1; i LTE count; i++){
		dbo = u.newDBObjectFromStruct( st );
	}
	total = getTickCount() - startTS;


</cfscript>