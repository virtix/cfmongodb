package com.mongodb;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

public class CFBasicDBObject extends com.mongodb.BasicDBObject{

	private static final long serialVersionUID = 1L;

	public static CFBasicDBObject newInstance(){
		return new CFBasicDBObject();
	}
	
	public CFBasicDBObject(){
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
		super.put(key, toJavaType(val));
		return this;
	}
	
	
	public Object toJavaType(Object val){
		if( val == null ) return "";
		
		if(val instanceof java.lang.String){
			String sval = (java.lang.String) val;
			String svalLC = sval.toLowerCase();
			if( svalLC.equals("false") ) return false;
			if( svalLC.equals("true") ) return true;
			
			
			try {
				return Long.parseLong(sval);
			} catch (Exception e) {
				//nothing; it's not a long
			}
			
			try {
				return Float.parseFloat(sval);
			} catch (Exception e) {
				//nothing; it's not a float
			}
			
			
		} else if ( val instanceof List ){
			
			try {
				List array = (List) val;
				Vector newArray = new Vector();
				for (Iterator iterator = array.iterator(); iterator.hasNext();) {
					newArray.add( toJavaType((Object) iterator.next()) );					
				}
				return newArray;
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			
		} else if( val instanceof Map ){
			
			try {
				Map map = (Map) val;
				return new CFBasicDBObject(map);
				
			} catch (Exception e) {
				System.out.println(e.toString());
			}
			
		}
		
		return val;
	}
	
}
