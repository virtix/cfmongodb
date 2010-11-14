component{
	this.name = "cfmongodb_people";


	function onApplicationStart(){
		variables.dbname = "mongorocks";
		include "../initMongo.cfm";
		application.mongo = mongo;
		application.collection = "people_list";

		include "load.cfm";
	}

	function onRequestStart(){
		if( structKeyExists(url, "reload") ){
			applicationStop();
		}
	}

	function onApplicationStop(){
		application.mongo.close();
	}

}
