<!---
Original Author:		Ciarán Archer

Desc:       Set of MXUnit tests to verify Mongo.cfc authentication functionality
			works.

			Note: presumes that mongod was started with --auth, BUT we don't run tests against an authenticated mongod. Consequently,
			we have to mock these behaviors and test that *our* code responds against what we currently know to be MongoDB's behavior
			when running a DB in auth mode

			If you run these tests with --auth, they will no doubt fail

			More info here: http://www.mongodb.org/display/DOCS/Security+and+Authentication

--->

<!---


WHERE I AM with these tests

1) need to add a user to admin.system.users or do whatever it takes to see what actually happens when an authenticated attempt fails due to not being authed
2) spoof the query() function to throw a similar error
3) have mongo.init() check for authentication required and work that into authenticate()
4) get these tests testing that behavior.

NOTE: to get this working:

use admin
db.addUser("one","one")

then attempted to query against it

 --->

<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
	import cfmongodb.core.*;

	variables.testDatabase = "cfmongodb_auth_tests";
	variables.testCollection = "authtests";
	variables.javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init();
	variables.mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(dbName=variables.testDatabase, mongoFactory=javaloaderFactory);
	variables.mongoConfig.setAuthDetails("username", "verysecurepassword!");

	function init_should_error_when_authentication_fails() {
		expectException("AuthenticationFailedException");

		var mongo = createObject('component','cfmongodb.core.Mongo');
		//we entirely spoof the authentication internals
		injectMethod(mongo, this, "isAuthenticationRequiredOverride", "isAuthenticationRequired");
		injectMethod(mongo, this, "authenticateOverride", "authenticate");

		mongo.init(mongoConfig);
	}

	function tearDown(){

		var mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig);
		try{
			mongo.dropDatabase();
		}catch(any e){
			debug("error dropping database");
			debug(e);
		}

		//close connection
		mongo.close();

	}

	private function isAuthenticationRequiredOverride(){ return true; }
	private function authenticateOverride(){ return {authenticated=false, error={}}; }


</cfscript>
</cfcomponent>

