<cfcomponent output="false" hint="Convenience wrapper for MongoDB. @see components.MongoDB for wrapper details">

<cfscript>
	function init(){
		return createObject('component','components.MongoDB');
	}

</cfscript>


</cfcomponent>