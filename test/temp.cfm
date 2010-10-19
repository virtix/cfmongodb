<!---<cfset structclear(server)>--->
<cfdump var="#server#">
<cfscript>



	javaPaths = directoryList( expandPath("/cfmongodb/lib"), false, "path", "*.jar" );
	binPath = expandPath("/cfmongodb/java/bin/");
	arrayappend(javaPaths, binPath);
	javaloader = createObject('component','cfmongodb.lib.javaloader.javaloader').init(javaPaths);
	javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init(javaloader);
	mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(db_name="cfmongodb_tests", mongoFactory=javaloaderFactory);
	mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig);


	i = 1;
	count = 200;
	u = mongo.getMongoUtil();
	st = {
		string="string",number=1,float=1.5,date=now(),boolean=true,
		array = ["one",1,5], struct = {one="one",two=2,bool=false},
		arrayOfStruct = [ {one=1, two="two"}, {three=3, four="four"} ]
	};
	startTS = getTickCount();
	for(i=1; i LTE count; i++){
		dbo = u.toMongo( st );
	}
	total = getTickCount() - startTS;

	writeDump(dbo.toString());

	mongo.save(st,"people");


	result = mongo.query("people").between("age",5,45).search();


	writeDump(result.getQuery().toString());




</cfscript>