<cfcomponent output="false">
<cfscript>
this.title = '';
this.body = '';
this.tags = [];
this.author = '';
this.pub_data = now();
this.comments = [
  comment= {
  comment_author = 'Coward',
  comment_email = '',
  comment_www = '',
  comment_text = ''}
 ];

</cfscript>
</cfcomponent>