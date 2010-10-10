<cfcomponent accessors="true">

	<cfproperty name="mongoFactory">

<cfscript>

	function init(mongoFactory=""){
		if(isSimpleValue(mongoFactory)){
			arguments.mongoFactory = createObject("component", "DefaultFactory");
		}
		variables.mongoFactory = arguments.mongoFactory;
		variables.dboFactory = mongoFactory.getObject('com.mongodb.CFBasicDBObject');
	}

	function newDBObject(){
		return dboFactory.newInstance();
	}

	function toMongo(any data){
		//for now, assume it's a struct to DBO conversion
		var dbo = newDBObject();
		dbo.putAll( data );
		return dbo;
	}

	function toCF(BasicDBObject){
		var s = {};
		s.putAll(BasicDBObject);
		return s;
	}

	function newObjectIDFromID(String id){
		return mongoFactory.getObject("org.bson.types.ObjectId").init(id);
	}

	function newIDCriteriaObject(String id){
		return newDBObject().put("_id",newObjectIDFromID(id));
	}

	/*
	function toJavaType(value){
		return value;
		if(isNull(value)) return "";
		if(not isNumeric(value) AND isBoolean(value)) return javacast("boolean",value);
		if(isNumeric(value) and find(".",value)) return javacast("double",value);
		if(isNumeric(value)) return javacast("long",value);
		return value;
	}*/

</cfscript>
</cfcomponent>