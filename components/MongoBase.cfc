<cfcomponent>
<cfscript>

	/*       OBJECT HELPER FUNCTIONS           */
	public function newDBObjectFromStruct(Struct data){
		return createObject("java","com.mongodb.BasicDBObject").init(data);
	}

	public function newDBObject(String key, any value){
		return createObject("java","com.mongodb.BasicDBObject").init(key,value);
	}

	public function newObjectIDFromID(String id){
		return createObject("java","com.mongodb.ObjectId").init(id);
	}

	public function newIDCriteriaObject(String id){
		return newDBObject("_id",newObjectIDFromID(id));
	}

	public struct function dbObjectToStruct(BasicDBObject){
		var s = {};
		s.putAll(BasicDBObject);
		return s;
	}

	public function toJavaType(value){
		if(not isNumeric(value) AND isBoolean(value)) return javacast("boolean",value);
		if(isNumeric(value) and find(".",value)) return javacast("double",value);
		if(isNumeric(value)) return javacast("int",value);
		return value;
	}

</cfscript>
</cfcomponent>