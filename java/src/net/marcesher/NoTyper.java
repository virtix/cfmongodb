package net.marcesher;

public class NoTyper implements Typer {

	private final static Typer instance = new NoTyper();
	
	public static Typer getInstance(){
		return instance;
	}
	
	@Override
	public Object toJavaType(Object val) {
		return val;
	}

}
