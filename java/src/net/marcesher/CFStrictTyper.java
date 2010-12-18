package net.marcesher;

import java.math.BigDecimal;
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
	public Object toJavaType(Object val){
		if( val == null ) return "";
		
		if(val instanceof java.lang.String){
			return handleSimpleValue(val);		
		} else if ( val instanceof List ){			
			return handleArray(val);		
		} else if( val instanceof Map ){			
			return handleMap(val);		
		} 
		
		return val;
	}

	public Object handleSimpleValue(Object val) {
		String sval = (java.lang.String) val;
		String svalLC = sval.toLowerCase();
		
		//CF booleans
		if( svalLC.equals("false") ) return false;
		if( svalLC.equals("true") ) return true;
		
		//CF numbers
		//my testing showed that it was faster to let these fall through rather than check for alpha characters via string.matches() and then parse the numbers. 
		try {
			return Integer.parseInt(sval);
		} catch (Exception e) {
			//nothing; it's not an int
		}
		
		try {
			return Long.parseLong(sval);
		} catch (Exception e){
			//nothing; it's not a long
		}
		
		try {
			return Float.parseFloat(sval);
		} catch (Exception e) {
			//nothing; it's not a float
		}
		return val;
	}

	public Object handleArray(Object val) {
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
	}

	public Object handleMap(Object val) {
		try {
			Map map = (Map) val;
			Map ts = new TypedStruct( map, instance );
			return ts ;				
		} catch (Exception e) {
			System.out.println("Exception creating DBObject from Map: " + e.toString());
			return val;
		}
	}
	
}
