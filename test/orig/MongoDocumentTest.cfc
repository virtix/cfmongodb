<cfcomponent extends="BaseTest" output="false">
<cfscript>
function testBuild(){
  mongo = createObject('component','cfmongodb.components.MongoDB');
  
  prog = mongo.new_doc('programmers');
  prog.set('name','bill');
  prog.save();
  debug(prog);
  prog2 = mongo.build_doc( prog );
  debug(prog2);
  assertNotSame( prog, prog2 );
  assertEquals( prog, prog2 );
  
}
</cfscript>
</cfcomponent>