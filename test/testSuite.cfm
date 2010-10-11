<cfparam name="URL.output" default="html">
<cfscript>	
	testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();
	testSuite.addAll("cfmongodb.test.BaseTestCase");
	testSuite.addAll("cfmongodb.test.MongoTest");
   	results = testSuite.run();
</cfscript>
<cfoutput>#results.getResultsOutput(URL.output)#</cfoutput>  
<!--- <p><hr /></p>
<p>Using CFDUMP against <code>mxunit.TestResult.getResults()</code> method</p>
<cfdump var="#results.getResults()#" label="MXUnit Sample Test Results" />
 --->