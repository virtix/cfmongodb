package net.marcesher;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;


public class TypedStruct extends HashMap {
	
	private Typer typer = CFStrictTyper.getInstance();
	private static final long serialVersionUID = 1L;
	
	//factory methods. This way, you can create an instance of a TypedStruct, and then use that instance to get new instances. This improves performance when working with javaloader, because you only need to have javaloader create a single instance of TypedStruct, and from there you can use that instance to create new TypedStructs
	public TypedStruct newInstance(){
		return new TypedStruct();
	}
	
	public TypedStruct newInstance(Map other){
		return new TypedStruct(other);
	}	
	
	public TypedStruct newInstance(Typer typer){
		return new TypedStruct(typer);
	}
	
	public TypedStruct newInstance(Map other, Typer typer){
		return new TypedStruct(other, typer);
	}
	
	//Constructors
	public TypedStruct(){}
	
	public TypedStruct(Map other){
		putAll(other);
	}
	
	public TypedStruct(Typer typer){
		this.typer = typer;
	}
	
	public TypedStruct(Map other, Typer typer){
		this.typer = typer;
		putAll(other);
	}
	
	//Overrides
	public Object put(Object key, Object val){
		super.put(key, typer.toJavaType(val));
		return this;
	}
	
	public Object append(String key, Object val){
		return put(key, val);
	}
}
