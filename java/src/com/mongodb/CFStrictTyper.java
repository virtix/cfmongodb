package com.mongodb;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

public class CFStrictTyper {
	
	public Object toJavaType(Object val){
		if( val == null ) return "";
		
		if(val instanceof java.lang.String){
			String sval = (java.lang.String) val;
			String svalLC = sval.toLowerCase();
			
			//CF booleans
			if( svalLC.equals("false") ) return false;
			if( svalLC.equals("true") ) return true;
			
			//CF numbers
			//my testing showed that it was faster to let these fall through rather than check for alpha characters via string.matches() and then parse the numbers. 
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
		
		//CF Arrays
		} else if ( val instanceof List ){
			
			try {
				List array = (List) val;
				Vector newArray = new Vector();
				for (Iterator iterator = array.iterator(); iterator.hasNext();) {
					newArray.add( toJavaType((Object) iterator.next()) );					
				}
				return newArray;
			} catch (Exception e) {
				System.out.println("Exception creating DBObject from Array: " +e.toString());
				return val;
			}
		
		//CF Structs
		} else if( val instanceof Map ){
			
			try {
				Map map = (Map) val;
				return new CFBasicDBObject(map);				
			} catch (Exception e) {
				System.out.println("Exception creating DBObject from Map: " + e.toString());
				return val;
			}
			
		}
		
		//Ye olde String
		return val;
	}
	
}
