
<cfinclude template="../initMongo.cfm">
<cfscript>
collection = "tasks";
mongo.remove({},collection);
nextNum = 1;

pending = [];
for( i = nextNum; i <= randRange( nextNum+1, nextNum+100 ); i++ ){
	arrayAppend( pending, { N=i, OWNER='', DATA="Some data goes here #i#", STATUS="P", ADDEDTS=now() } );
}

running = [];
nextNum = i;
for( i = nextNum; i <= randRange( nextNum+1, nextNum+100 ); i++ ){
	owner = i mod 2 ? "localhost" : "someOtherServer";
	arrayAppend( running, { N=i, OWNER=owner, DATA="Some data goes here #i#", STATUS="R", ADDEDTS=dateAdd("d",-randRange(0,50),now()), STARTTS=now() } );
}

paused = [];
nextNum = i;
for( i = nextNum; i <= randRange( nextNum+1, nextNum+100 ); i++ ){
	arrayAppend( paused, { N=i, OWNER='', DATA="Some data goes here #i#", STATUS="U", ADDEDTS=dateAdd("d",-randRange(0,50),now()) } );
}

completed = [];
nextNum = i;
for( i = nextNum; i <= randRange( nextNum+1, nextNum+100 ); i++ ){
	owner = i mod 2 ? "localhost" : "someOtherServer";
	arrayAppend( paused, { N=i, OWNER=owner, DATA="Some data goes here #i#", STATUS="C", ADDEDTS=dateAdd("d",-randRange(1,50),now()), STARTTS=dateAdd("n",-randRange(0,500),now()), COMPLETETS=now() } );
}


mongo.saveAll( pending, collection );
mongo.saveAll( running, collection );
mongo.saveAll( paused, collection );
mongo.saveAll( completed, collection );

mongo.close();
</cfscript>