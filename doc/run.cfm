

<cfscript>
	colddoc = createObject("component", "ColdDoc").init();

	base = expandPath("/transfer");
	docs = expandPath("docs");

	colddoc.generate(base, docs, "transfer", "Transfer version 1.1");
</cfscript>


<h1>Done!</h1>
