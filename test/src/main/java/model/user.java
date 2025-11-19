package model;

public class user {
	public int uid;
	public String uname;
	public String passwordHash; // cái này dùn mã băm để cho an toàn
	public String email;
	public String fullname;
	public int phonenumber;

	public user(int uid, String uname, String passwordHash, String email, String fullname, int phonenumber) {
		super();
		this.uid = uid;
		this.uname = uname;
		this.passwordHash = passwordHash;
		this.email = email;
		this.fullname = fullname;
		this.phonenumber = phonenumber;
	}

	public int getUid() {
		return uid;
	}

	public void setUid(int uid) {
		this.uid = uid;
	}

	public String getUname() {
		return uname;
	}

	public void setUname(String uname) {
		this.uname = uname;
	}

	public String getPasswordHash() {
		return passwordHash;
	}

	public void setPasswordHash(String passwordHash) {
		this.passwordHash = passwordHash;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public int getPhonenumber() {
		return phonenumber;
	}

	public void setPhonenumber(int phonenumber) {
		this.phonenumber = phonenumber;
	}

}
