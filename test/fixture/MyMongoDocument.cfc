<cfcomponent persisten="true" extends="cfmongodb.components.MongoDocument" output="false">
<cfscript>
/* -------------------------------------------------
	** Syntax for defining a persistent model **
	
	  this.model = structNew();
	  this.model['name'] = 'default value';
----------------------------------------------------*/


	this.model = structNew();
	this.model['title'] = 'default';
	this.model['body'] = 'default';
	this.model['timestamp'] = getTickCount();
	this.model['tags'] = [];
	
	
</cfscript>
</cfcomponent>