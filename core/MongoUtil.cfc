<cfcomponent accessors="true">

	<cfproperty name="mongoFactory">

<cfscript>

	function init(mongoFactory=""){
		if(isSimpleValue(mongoFactory)){
			arguments.mongoFactory = createObject("component", "DefaultFactory");
		}
		variables.mongoFactory = arguments.mongoFactory;
		variables.dboFactory = mongoFactory.getObject('com.mongodb.CFBasicDBObject');
		variables.typerClass = getTyperClass();
		variables.typer = mongoFactory.getObject(typerClass).getInstance();
	}

	/**
	* Returns a passthrough typer for Railo b/c it knows that 1 is 1 and not "1"; returns the CFStrictTyper otherwise
	*/
	public function getTyperClass(){
		if( server.coldfusion.productname eq "Railo") return "net.marcesher.NoTyper";
		return "net.marcesher.CFStrictTyper";
	}

	function newDBObject(){
		return dboFactory.newInstance(variables.typer);
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
		if( not isSimpleValue( id ) ) return id;
		return mongoFactory.getObject("org.bson.types.ObjectId").init(id);
	}

	function newIDCriteriaObject(String id){
		return newDBObject().put("_id",newObjectIDFromID(id));
	}

	function createOrderedDBObject( keyValues ){
		var dbo = newDBObject();
		var kv = "";
		keyValues = listToArray(keyValues);
		for(kv in keyValues){
			var key = listFirst(kv, "=");
			var value = listLast(kv, "=");
			dbo.append( key, value );
		}
		return dbo;
	}

	function getDateFromDoc( doc ){
		var ts = doc["_id"].getTime();
		return createObject("java", "java.util.Date").init(ts);
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