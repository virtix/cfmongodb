<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>MongoDB/ColdFusion Blog Demo</title>
 <link type="text/css" rel="stylesheet" href="http://jqueryui.com/themes/base/ui.all.css" />

<script src="http://www.google.com/jsapi"></script>
<script>
  // Load jQuery
   google.load("jquery", "1.3.2");
   google.load("jqueryui", "1.7.2");
   google.setOnLoadCallback(function() {
     $(document).ready(function(){
	    $('#btnPost').bind('click',function(){

	      $.post('BlogFacade.cfc?method=createBlogPost',
	      		{title  : $('input[name=title]').val(),
	      		 author : $('input[name=author]').val(),
	       		 tags   : $('input[name=tags]').val(),
	       		 text   : $('textarea[name=text]').val()
	      		 },
	      		null, "json");

	      	$('#btnClear').click();
	      	location.href = 'demo.cfm';
	    });

	    $('#btnClear').bind('click',function(){
	       $('input[name=title]').val('');
	       $('input[name=author]').val('');
	       $('input[name=tags]').val('');
	       $('textarea[name=text]').val('');
	    });

	  });

	  $('.del').bind('click',function(){
	    //alert(this.id);
	    $.post('BlogFacade.cfc?method=deletePost', {id:this.id}, null, "json");
	    $('#p_'+this.id).html('');
	  });

   });

</script>
</head>
<body>
<h2>MongoDB/ColdFusion Blog Demo</h2>
<form>
Blog Title: <input type="text" name="title"><br />
Author: <input type="text" name="author"><br />
Tags:<input type="text" name="tags"><br />
Post:<br /><textarea cols="50" rows="10" name="text"></textarea><br />
<input type="button" id="btnPost" value="Create Blog Post">
<input type="button" id="btnClear" value="Clear">
</form>
<p><hr/></p>
<h3>Posts</h3>
<cfset mongo = createObject('component','MongoDB') />
<cfscript>
  //out = writeoutput;
  items = mongo.findAll();
  for(i=1;i<=arrayLen(items);i++){
  	post =  items[i];
  	id = post["_id"].toString();
   writeoutput( '<div id="p_#id#"><strong>' & post.title & '</strong>  <em>by ');
   writeoutput(post.author & '</em> on #dateFormat(post['PUB_DATE'],'mm/dd/yy')# #timeFormat(post['PUB_DATE'],'hh:mm:ss')# <br />');
   writeoutput(post.text & '<br />');
   writeoutput('<a href="javascript:void(0)" id="#id#" class="del">Delete</a>');
   writeoutput('<p><hr size="1" noshade /></p></div>');
  }
</cfscript>



</body>
</html>
