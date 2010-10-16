package com.mongodb;

import java.util.Map;

import net.marcesher.CFStrictTyper;
import net.marcesher.Typer;

public class CFBasicDBObject extends com.mongodb.BasicDBObject{

	private static final long serialVersionUID = 1L;
	private Typer typer = CFStrictTyper.getInstance();

	public static CFBasicDBObject newInstance(){
		return new CFBasicDBObject();
	}
	public static CFBasicDBObject newInstance(Typer typer){
		return new CFBasicDBObject(typer);
	}
	
	public CFBasicDBObject(){	
	}
	
	//in the event that someone wishes to write and inject their own typer object
	public CFBasicDBObject(Typer typer){
		this.typer = typer;
	}
	
	public CFBasicDBObject(String key, Object value){
		put(key, value);
	}
	
	public CFBasicDBObject(CFBasicDBObject other){
		super.putAll((Map)other);
	}
	
	public CFBasicDBObject(Map map) {
		super.putAll(map);
	}

	public Object put(String key, Object val){
		super.put(key, typer.toJavaType(val));
		return this;
	}
		
}
