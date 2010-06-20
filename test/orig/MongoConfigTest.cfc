<cfcomponent extends="BaseTest" output="false">
<cfscript>
function testConfig(){
  config = createObject('component','cfmongodb.components.MongoConfig');
  debug(config);
  assertEquals(config.defaults.collection_name, 'default_collection');
}
</cfscript>
</cfcomponent>