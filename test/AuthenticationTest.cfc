<!---         
*************************************************************************************
************************************ COMMENTS ***************************************
*************************************************************************************
        
Name:		AuthenticationTest.cfc
                
Author:		Ciarán Archer
Date:		27 December 2010

Params:          
     
Desc:       Set of MXUnit tests to verify Mongo.cfc authentication functionality
			works.    
			
			Note: presumes that mongod was started with --auth. 
			
			More info here: http://www.mongodb.org/display/DOCS/Security+and+Authentication

*************************************************************************************
*************************************************************************************
ADJUSTMENTS:


*************************************************************************************
--->
<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
	import cfmongodb.core.*;

	variables.testDatabase = "cfmongodb_test_auth";
	variables.testCollection = "myTestCollection";
	variables.javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init();
	variables.mongoConfig = createObject('component','cfmongodb.core.MongoConfig').init(dbName=variables.testDatabase, mongoFactory=javaloaderFactory);
	

function setUp() {
	
	// create cfmongodb instance
	variables.mongo = createObject('component','cfmongodb.core.Mongo').init(mongoConfig);
	
}

function testSaveWithoutCredentials() {

	// TODO: attempt to save a document without authenticating
	assertEquals(1, 1);
	
}


function testSaveWithCredentials() {
	
	// TODO: attempt to save a document after authenticating
	assertEquals(1, 1);
	
}



function tearDown(){

	// remove database
	variables.mongo.dropDatabase();
	
	//close connection
	variables.mongo.close();
	
}


</cfscript>
</cfcomponent>

