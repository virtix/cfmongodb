<cfcomponent>
<cfscript>
  
  /*---------------------------------------------------------------------
  
    DSL for MongoDB searches:   
    
    mongo.expressionBuilder().
    
    results = mongo.startsWith('name','foo'). //string
                    endsWith('title','bar').  //string
                    exists('field','value').  //string
					regex('field','value').   //string
                    eq('field','value').      //numeric
                    lt('field','value').      //numeric 
                    gt('field','value').      //numeric
                    gte('field','value').    //numeric
                    lte('field','value').    //numeric
                    in('field','value').     //array
                    nin('field','value').    //array
                    mod('field','value').    //numeric
                    size('field','value').   //numeric
					
                    search('title,author,date', limit, start);
    
    

    
    
    search(keys=[keys_to_return],limit=num,start=num);
    

  
  
-------------------------------------------------------------------------------------*/

builder = createObject('java', 'com.mongodb.BasicDBObjectBuilder').start();
pattern = createObject('java', 'java.util.regex.Pattern');

function startsWith(element, val){
  var regex = val & '.*';
  builder.add( element, pattern.compile(regex) );
  return this;
}

function endsWith(element, val){
  var regex = '.*' & val;
  builder.add( element, pattern.compile(regex) );
  return this;
}


function exists(element, val){
  var regex = '.*' & val & '.*';
  builder.add( element, pattern.compile(regex) );
  return this;
}


function regex(element, val){
  var regex = val;
  builder.add( element, pattern.compile(regex) );
  return this;
}


function $gt(element, val){
  //need to address all numeric values! 
  var exp = {};
  exp[element] = javacast('long', val);
  builder.add( '$gt', exp );
  return this;
}



function builder(){
  return builder;
}

function start(){
  return builder.start();
}

function get(){
  return builder.get();
}


</cfscript>
</cfcomponent>