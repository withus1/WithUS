package dao;

public class UserObj {
	private String id, name, ts, image;
	
	public UserObj(String id, String ts, String image) {
		this.id = id;
		this.ts = ts;
		this.image = image;
	}
	
	public String getId() { return this.id; }
	public String getName() { return this.name; }
	public String getTs() { return this.ts; }
	public String getImage() { return this.ts; }
}