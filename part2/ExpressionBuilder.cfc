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
                    gte('field','value').     //numeric
                    lte('field','value').     //numeric
                    in('field','value').      //array
                    nin('field','value').     //array
                    mod('field','value').     //numeric
                    size('field','value').    //numeric
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


function builder(){
  return builder;
}

function start(){
  return builder.start();
}

function get(){
  return builder.get();
}


//may need at least some exception handling
function $lt(element,val){
  return addNumericCriteria(element,val,'$lt');
}

function $lte(element,val){
  return addNumericCriteria(element,val,'$lte');
}

function $gt(element,val){
  return addNumericCriteria(element,val,'$gt');
}


function $gte(element,val){
  return addNumericCriteria(element,val,'$gte');
}

</cfscript>

<!--- 
Note to self: Using cffunction here because of the ability/need to cast
arbitrary numeric data to java without using JavaCast. CFARGUMENT takes care
of that. CF9 might too, but most folks are still < CF9.

But, this also proved to be a very good refactor.
 --->

<cffunction name="addNumericCriteria" hint="refactored $expressions for numerics">
	<cfargument name="element" type="string" hint="The element in the document we're searching"/>
    <cfargument name="val" type="numeric" hint="The comparative value of the element" />
	<cfargument name="type" type="string" hint="$gt,$lt,etc. The operators - <><=>= ..." />
	<cfscript>  
  		var exp = {};
  		exp[type] = val;
  		builder.add( element, exp );
  		return this;
  	</cfscript>
</cffunction>

</cfcomponent>