<cfcomponent extends="BaseTest" output="false">
<cfscript>
function whatUp(){
  obj = createObject( 'component','fixture.SomeCFCWithProperties');
  model = obj['MODEL']; 
  debug( model );
  assertEquals( model['name'], 'bill' );
  assertEquals( model['address'], '' );
  assertEquals( model['city'], '' );
  
  obj.save();
 
  
}

function testCreate(){
  c = createObject( 'component','fixture.SomeCFCWithProperties').init('foo','123 main st','anytown');
  debug( getMetaData(c) );
  debug(c);

}

</cfscript>
</cfcomponent>