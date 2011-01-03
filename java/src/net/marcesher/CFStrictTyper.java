package net.marcesher;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;


public class CFStrictTyper implements Typer {
	
	private final static Typer instance = new CFStrictTyper();
	
	public static Typer getInstance(){
		return instance;
	}
	
	private CFStrictTyper(){}
	
	/* (non-Javadoc)
	 * @see com.mongodb.Typer#toJavaType(java.lang.Object)
	 */
	@Override
	public Object toJavaType(Object value){
		if( value == null ) return "";
		
		if(value instanceof java.lang.String){
			return handleSimpleValue(value);		
		} else if ( value instanceof List ){			
			return handleArray(value);		
		} else if( value instanceof Map ){			
			return handleMap(value);		
		} 
		
		return value;
	}

	public Object handleSimpleValue(Object value) {
		String stringValue = (java.lang.String) value;
		String stringValueLowerCase = stringValue.toLowerCase();
		
		//CF booleans
		if( stringValueLowerCase.equals("false") ) return false;
		if( stringValueLowerCase.equals("true") ) return true;
		
		//CF numbers
		//my testing showed that it was faster to let these fall through rather than check for alpha characters via string.matches() and then parse the numbers. 
		try {
			return Integer.parseInt(stringValue);
		} catch (Exception e) {
			//nothing; it's not an int
		}
		
		try {
			return Long.parseLong(stringValue);
		} catch (Exception e){
			//nothing; it's not a long
		}
		
		try {
			return Float.parseFloat(stringValue);
		} catch (Exception e) {
			//nothing; it's not a float
		}
		return value;
	}

	public Object handleArray(Object value) {
		try {
			List array = (List) value;
			Vector newArray = new Vector();
			for (Iterator iterator = array.iterator(); iterator.hasNext();) {
				newArray.add( toJavaType((Object) iterator.next()) );					
			}
			return newArray;
		} catch (Exception e) {
			System.out.println("Exception creating DBObject from Array: " +e.toString());
			return value;
		}
	}

	public Object handleMap(Object value) {
		try {
			Map map = (Map) value;
			Map ts = new TypedStruct( map, instance );
			return ts ;				
		} catch (Exception e) {
			System.out.println("Exception creating DBObject from Map: " + e.toString());
			return value;
		}
	}
	
}
