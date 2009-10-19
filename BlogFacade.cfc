<cfcomponent output="false">
<cfscript>
mongo = createObject('component','MongoDB');
</cfscript>


<cffunction name="createBlogPost" access="remote">
 <cfargument name="title" />
 <cfargument name="author" />
 <cfargument name="tags" />
 <cfargument name="text" />
 <cfscript>
   blog = createObject('component','Blog');
   blog.title = arguments.title;
   blog.author = arguments.author;
   blog.tags = listToArray(arguments.tags);
   blog.text = arguments.text;
   mongo.put(blog);
 </cfscript>
  
</cffunction>


<cffunction name="getBlogPosts" access="remote">
 <cfreturn mongo.find() />
</cffunction>

<cffunction name="deletePost" access="remote">
 <cfargument name="id" type="string" />
 <cfset mongo.deleteById(id) />
</cffunction>

</cfcomponent>