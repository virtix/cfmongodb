<cfset javaloaderFactory = createObject('component','cfmongodb.core.JavaloaderFactory').init()>
<cfset mongoConfig =
createObject('component','cfmongodb.core.MongoConfig').init([{serverName='flame.mongohq.com',serverPort='27046'}],'timber', javaloaderFactory)>
<cfset mongoConfig =
createObject('component','cfmongodb.core.MongoConfig').init([{serverName='localhost',serverPort='27017'}],'timber', javaloaderFactory)>
<cfset mongoConfig.setAuthDetails('user@some.com','xxxxxx')>
<cfset mongo =
createObject('component','cfmongodb.core.Mongo').init(mongoConfig)>

<cfdump var="#mongo#">