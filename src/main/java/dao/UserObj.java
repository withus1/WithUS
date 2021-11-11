package dao;

public class UserObj {
	private String id, name, ts;
	
	public UserObj(String id, String ts) {
		this.id = id;
		this.ts = ts;
	}
	
	public String getId() { return this.id; }
	public String getName() { return this.name; }
	public String getTs() { return this.ts; }
}