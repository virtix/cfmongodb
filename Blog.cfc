<cfcomponent output="false">
<cfscript>
this.id = '';
this.title = '';
this.body = '';
this.tags = [];
this.author = '';
this.pub_date = now();
this.comments = [
  comment= {
  comment_author = 'Coward',
  comment_email = '',
  comment_www = '',
  comment_text = ''}
 ];

</cfscript>
</cfcomponent>