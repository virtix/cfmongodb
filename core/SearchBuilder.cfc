<cfcomponent hint="Creates a Domain Specific Language (DSL) for querying MongoDB collections.">
<cfscript>

  /*---------------------------------------------------------------------

    DSL for MongoDB searches:

    mongo.query('collection_name').

    results = mongo.startsWith('name','foo').  //string
                    endsWith('title','bar').   //string
                    exists('field','value').   //string
					          regex('field','value').    //string
                    eq('field','value').       //numeric
                    lt('field','value').       //numeric
                    gt('field','value').       //numeric
                    gte('field','value').      //numeric
                    lte('field','value').      //numeric
                    in('field','value').       //array
                    nin('field','value').      //array
                    mod('field','value').      //numeric
                    size('field','value').     //numeric
                    after('field','value').    //date
                    before('field','value').   //date
                    search('title,author,date', limit, start);

    search(keys=[keys_to_return],limit=num,start=num);

-------------------------------------------------------------------------------------*/

builder = '';
pattern = '';
collection = '';
mongoFactory = '';
mongoUtil = '';

function init(string coll, any db, any mongoUtil){
 variables.mongoUtil = arguments.mongoUtil;
 variables.mongoFactory = arguments.mongoUtil.getMongoFactory();
 builder = mongoFactory.getObject('com.mongodb.BasicDBObjectBuilder').start();
 pattern = createObject('java', 'java.util.regex.Pattern');
 collection = db.getCollection(coll);
}

function startsWith(element, val){
  var regex = '^' & val;
  builder.add( element, pattern.compile(regex) );
  return this;
}

function endsWith(element, val){
  var regex = val & '$';
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
  builder.start();
  return this;
}

function get(){
  return builder.get();
}


//May need at least some exception handling
function where( js_expression ){
 builder.add( '$where', js_expression );
 return this;
}

function inArray(element, val){
  builder.add( element, mongoUtil.toJavaType(val) );
  return this;
}

 //vals should be list or array
function $in(element,vals){
  if(isArray(vals)) return addArrayCriteria(element,vals,'$in');
  return addArrayCriteria(element, listToArray(vals),'$in');
}

function $nin(element,vals){
  if(isArray(vals)) return addArrayCriteria(element,vals,'$nin');
  return addArrayCriteria(element, listToArray(vals),'$nin');
}


function $eq(element,val){
  builder.add( element, mongoUtil.toJavaType(val) );
  return this;
}


function $ne(element,val){
  return addNumericCriteria(element,val,'$ne');
}


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

function between(element, lower, upper){
	$gte(element, lower);
	return $lte(element, upper);
}

function listToStruct(list){
  var item = '';
  var s = {};
  var i = 1;
  for(i; i lte listlen(list); i++) {
   s.put(listgetat(list,i),1);
  }
  return s;
}



</cfscript>

<cffunction name="search">
  <cfargument name="keys" type="string" required="false" default="" hint="A list of keys to return" />
  <cfargument name="skip" type="numeric" required="false" default="0" hint="the number of items to skip"/>
  <cfargument name="limit" type="numeric" required="false" default="0" hint="Number of the maximum items to return" />
  <cfargument name="sort" type="struct" required="false" default="#structNew()#" hint="A struct representing how the items are to be sorted" />
  <cfscript>
   var key_exp = listToStruct(arguments.keys);
   var _keys = mongoFactory.getObject('com.mongodb.BasicDBObject').init(key_exp);
   var search_results = [];
   var criteria = get();
   var q = mongoFactory.getObject('com.mongodb.BasicDBObject').init(criteria);
   //writeLog("MongoDB Search on Collection #collection.toString()#: " & q.toString() & "; criteria was : " & criteria.toString());
   search_results = collection.find(q,_keys).limit(limit).skip(skip).sort(mongoUtil.newDBObjectFromStruct(sort));

   //totalCount = collection.getCount(q);
   //writelog(totalcount);
   return createObject("component", "SearchResult").init( search_results, mongoUtil );
  </cfscript>
</cffunction>



<cffunction name="before">
  <cfargument name="element" type="string" />
  <cfargument name="val" type="date" />
   <cfscript>
  		var exp = {};
  		var  date = parseDateTime(val);
  		exp['$lte'] = date;
  		builder.add( element, exp );
  		return this;
  	</cfscript>
</cffunction>


<cffunction name="after">
  <cfargument name="element" type="string" />
  <cfargument name="val" type="date" />
   <cfscript>
  		var exp = {};
  		var  date = parseDateTime(val);
  		exp['$gte'] = date;
  		builder.add( element, exp );
  		return this;
  	</cfscript>
</cffunction>

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

<cffunction name="addArrayCriteria" hint="refactored $expressions for numerics">
	<cfargument name="element" type="string" hint="The array element in the document we're searching"/>
  <cfargument name="val" type="array" hint="The value(s) of an element in the array" />
	<cfargument name="type" type="string" hint="$in,$nin,etc." />
	<cfscript>
  		var exp = {};
  		exp[type] = val;
  		builder.add( element, exp );
  		return this;
  	</cfscript>
</cffunction>


</cfcomponent>