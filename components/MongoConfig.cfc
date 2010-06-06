<cfcomponent extends="MongoBase" output="false" hint="Main configuration information for MongoDb connections. Defaults are provided, but should be changed as needed. ">
<cfscript>
  
 //Default values
 this.defaults = {
  server_name = 'localhost',
  server_port = 27017,
  db_name = 'default_db',
  collection_name = 'default_collection'
 };

</cfscript>
</cfcomponent>