<cfcomponent>
<cfscript>
	function newDBObject(){
		return createObject('java', 'com.mongodb.BasicDBObject');
	}

	function newDBObjectFromStruct(Struct data){
		var key = "";
		var dbo = newDBObject();
		for(key in data){
			dbo.put(key,toJavaType(data[key]));
		}
		return dbo;
	}

	function newObjectIDFromID(String id){
		return createObject("java","org.bson.types.ObjectId").init(id);
	}

	function newIDCriteriaObject(String id){
		return newDBObject().init("_id",newObjectIDFromID(id));
	}

	function dbObjectToStruct(BasicDBObject){
		var s = {};
		s.putAll(BasicDBObject);
		return s;
	}

	function toJavaType(value){
		if(not isNumeric(value) AND isBoolean(value)) return javacast("boolean",value);
		if(isNumeric(value) and find(".",value)) return javacast("double",value);
		if(isNumeric(value)) return javacast("long",value);
		return value;
	}

</cfscript>
</cfcomponent>