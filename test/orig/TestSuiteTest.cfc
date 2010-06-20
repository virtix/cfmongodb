<cfcomponent extends="mxunit.framework.TestCase" output="false">
<cfscript>

function testThis(){
	suite = createObject('component','mxunit.framework.TestSuite').TestSuite();
	suite.addAll('cfmongodb.test.DocumentTest');
	results = suite.run();
	//debug(results);
}

</cfscript>

</cfcomponent>