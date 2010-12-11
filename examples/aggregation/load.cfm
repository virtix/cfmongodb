
<cfinclude template="../initMongo.cfm">
<cfscript>
collection = "tasks";
mongo.remove({},collection);
nextNum = 1;
//abort;


pending = [];
for( i = nextNum; i <= randRange( nextNum+1, nextNum+100 ); i++ ){
	arrayAppend( pending, { N=i, OWNER=cgi.SERVER_NAME, DATA="Some data goes here #i#", STATUS="P" } );
}

running = [];
nextNum = i;
for( i = nextNum; i <= randRange( nextNum+1, nextNum+100 ); i++ ){
	arrayAppend( running, { N=i, OWNER=cgi.SERVER_NAME, DATA="Some data goes here #i#", STATUS="R" } );
}

paused = [];
nextNum = i;
for( i = nextNum; i <= randRange( nextNum+1, nextNum+100 ); i++ ){
	arrayAppend( paused, { N=i, OWNER=cgi.SERVER_NAME, DATA="Some data goes here #i#", STATUS="U" } );
}


mongo.saveAll( pending, collection );
mongo.saveAll( running, collection );
mongo.saveAll( paused, collection );

mongo.close();
</cfscript>