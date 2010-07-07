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

	function getObjectIDFromID(String id){
		return createObject("java","com.mongodb.ObjectId").init(id);
	}

	function dbObjectToStruct(BasicDBObject){
		var s = {};
		s.putAll(BasicDBObject);
		return s;
	}

	function newIDCriteriaObject(String id){
		return newDBObject("_id",getObjectIDFromID(id));
	}

	function toJavaType(value){
		if(not isNumeric(value) AND isBoolean(value)) return javacast("boolean",value);
		if(isNumeric(value) and find(".",value)) return javacast("double",value);
		if(isNumeric(value)) return javacast("int",value);
		return value;
	}

</cfscript>
</cfcomponent>