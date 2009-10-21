<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
  
  /*---------------------------------------------------------------------
  
    exp = {
      name='$eq'
    };
    
    
    mongo.expressionBuilder().
    
    mongo.search(collection, exp);
    
    //searches current collection
    results = mongo.startsWith('name','foo').
                    endsWith('title','bar').
                    contains('field','value').
                    eq('field','value').
                    lt('field','value').
                    gt('field','value').
                    gte('field','value').
                    lte('field','value').
                    in('field','value').
                    nin('field','value').
                    exits('field','value').
                    mod('field','value').
                    size('field','value').
                    search('title,author,date');
    
    
    Come up with DSL for MongoDB searches:
    
    
    search(keys=[keys_to_return],limit=num,start=num);
    
    Note: Look at aggregation
  
  
  
  */
 
  function $findByRegEx(){
    coll = mongo.getCollection('blog');
    //raw = mongo.getMongo(); //raw jo
    debug(coll.getName());
    //debug(coll);
    //import java.util.regex.Pattern;
    //import java.util.regex.Matcher;
    p = createObject('java', 'java.util.regex.Pattern').compile('bill_6[0-2].*');
    exp = { AUTHOR=p, };
    key_exp = {AUTHR=1,TITLE=1};
    keys = createObject('java', 'com.mongodb.BasicDBObject').init(key_exp);
    q = createObject('java', 'com.mongodb.BasicDBObject').init(exp);
    items = coll.find( q, keys );
    debug(items.count());
    debug(items.toArray().toString());
    
  }
 
 
  function genDataTest(){
    //genBlogData();
  }
  
   
  function setUp(){
     mongo = createObject('component','MongoDB');
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>

<cffunction name="genBlogData" access="package">
  <cfscript>
	var i = 0;
	var entry = {foo='bar'};
	var start = getTickCount();
	mongo.getCollection('blog');
	for(i; i < 1000;i++){
	 entry.title = 'Blog Title No.' & i;
	 entry.author = 'bill_' & i;
	 entry.ts = getTickCount();
	 entry.body = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In eu justo lectus. Morbi aliquet consectetur consequat. Mauris mauris nulla, condimentum in aliquet nec, suscipit in lacus. Donec vel ante ut metus imperdiet interdum. Curabitur non sapien at felis egestas bibendum in eu urna. In rutrum ligula erat. Integer tristique viverra consequat. Curabitur tristique velit vel nunc aliquet congue eleifend lacus cursus. Aenean a lorem a arcu tincidunt tempus. Nulla faucibus diam in sem consequat tincidunt. Aenean quis nunc vitae leo luctus porta. Etiam justo enim, imperdiet vel commodo sed, placerat nec dolor. Nunc placerat sapien id ligula varius eget tempus est eleifend.

Vivamus ipsum justo, interdum ut blandit feugiat, tempus id erat. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla dignissim eros quis velit vestibulum ullamcorper. Donec mattis venenatis augue sed semper. Donec egestas dapibus mauris cursus elementum. Phasellus egestas porta quam vitae sodales. Vestibulum ut tortor vitae enim mollis placerat. Sed tortor orci, venenatis sit amet auctor in, condimentum vitae enim. In vel nulla velit. Proin ultrices vehicula nibh a interdum. Integer rhoncus luctus est sit amet placerat. In commodo, mauris id consectetur pulvinar, massa nibh condimentum nunc, non fermentum lacus turpis vitae nisl. Curabitur at dui eu leo laoreet luctus in eu diam. Aliquam ante velit, venenatis sit amet sollicitudin non, adipiscing in orci. Curabitur tristique bibendum volutpat. Donec blandit tempor vestibulum. Sed lorem justo, fringilla vel hendrerit sit amet, pellentesque lobortis turpis. Integer sed turpis quis dolor suscipit mollis in a nibh. Aenean blandit condimentum erat, eget consequat erat cursus eu. Vestibulum in massa tortor.

In adipiscing, purus in ultrices euismod, tortor mauris congue felis, vel tincidunt leo sapien sit amet urna. Etiam id augue enim, non facilisis lectus. Vestibulum tincidunt nulla ut tortor faucibus a luctus elit pellentesque. Donec ornare lacus quis lorem vulputate tristique. Nulla facilisi. Donec pretium, risus sit amet volutpat tempor, mi tellus molestie dui, sit amet volutpat nibh enim at orci. Aliquam metus urna, posuere ac pulvinar a, consequat in erat. Fusce sed tortor mi. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vestibulum tempus placerat luctus. Nam convallis, justo et accumsan porta, quam felis semper lorem, in tristique leo dui et turpis. In hendrerit lacinia tellus condimentum ullamcorper. Suspendisse neque massa, convallis eu accumsan et, fringilla in ante. Integer in urna at tellus ultricies semper in at justo. Phasellus ac neque in magna pharetra aliquet. Integer vehicula pharetra magna a blandit. Vestibulum in aliquet mauris. Fusce molestie libero sed nunc accumsan lacinia. Morbi posuere auctor vehicula. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.

In eget dui eu justo ullamcorper cursus. Duis convallis nisi tincidunt neque semper a suscipit magna sagittis. Vivamus sodales augue a odio congue ac iaculis erat accumsan. Morbi at neque non ipsum eleifend varius. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aenean fermentum velit in nisi porta eu aliquet diam dictum. Curabitur eleifend ornare nisi, ac commodo urna aliquam a. In at eros enim, et porta augue. Morbi at convallis ligula. Sed odio elit, ultricies vel porta id, dictum id nunc. Nulla massa metus, rhoncus quis consectetur ac, pellentesque at dolor. Vestibulum elementum, metus vitae porttitor pulvinar, neque est interdum nulla, ut placerat enim nunc eu purus. In ac risus et ligula dignissim condimentum. Sed quis elit mauris, mollis bibendum odio. Nullam diam mi, semper eu malesuada in, mattis in lacus. Mauris varius, neque vitae vestibulum hendrerit, nisl risus porta metus, vel dignissim tortor arcu eu erat.

Aenean sapien mi, gravida cursus varius a, faucibus non elit. Etiam bibendum mollis orci id dignissim. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; In nisi enim, vestibulum eu sollicitudin vitae, ultricies vitae tortor. Aliquam sed turpis quis enim lobortis suscipit nec et nisi. Pellentesque a nisi erat. Mauris congue ultricies libero, nec tempus ipsum ullamcorper quis. Integer varius magna a lectus fringilla et ultrices augue molestie. Quisque eget interdum est. Nunc cursus pellentesque risus, tempus hendrerit mauris imperdiet ut. Maecenas a orci in nulla varius lacinia sit amet quis urna. Pellentesque lacinia consequat mollis. Vestibulum vel odio lectus, luctus viverra dui. Sed sed arcu velit, at pharetra ligula. Praesent convallis commodo mi ut laoreet. ';
	//dump(entry);
	mongo.put(entry);
	}
	debug(getTickCount()-start);
	
  </cfscript>
</cffunction>
<!---  
 --->
</cfcomponent>