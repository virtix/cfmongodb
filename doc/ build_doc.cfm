<cfscript>
g = createObject('component','ColdDoc').init();
//src = '/home/billy/software/railo/webroot/cfmongodb/';
src = expandPath("/cfmongodb");
//out = "/home/billy/software/railo-3.1.1.000-railo-express-with-jre-linux/webroot/cfmongodb/doc/api";
out = expandPath("/cfmongodb/doc/api");
g.generate(src,out,'cfmongodb' , 'CFMongoDB API');
</cfscript>
<a href="api/">View results</a>