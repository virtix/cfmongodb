<cfcomponent output="false">
<cfscript>
this.id = '';
this.title = '';
this.body = '';
this.tags = [];
this.author = '';
this.pub_date = now();
this.comments = arrayNew(1); 

this.comment = {
comment_author = 'Coward',
comment_email = '',
comment_www = '',
comment_text = ''};

this.comments[1] = this.comment;
</cfscript>
</cfcomponent>