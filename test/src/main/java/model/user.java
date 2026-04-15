package model;

public class user {
	public int uid;
	public String username;
	public String passwordHash;
	public String email;
	public String fullname;
	public String phonenumber;
	public String avatar; 
	private int isAdmin;

    public user() {
    }

    public user(int uid, String uname, String passwordHash, String email, String fullname, String phonenumber, String avatar, int isAdmin) {
        this.uid = uid;
        this.username = uname;
        this.passwordHash = passwordHash;
        this.email = email;
        this.fullname = fullname;
        this.phonenumber = phonenumber;
        this.avatar = avatar;
        this.isAdmin = isAdmin;   
        }

	public int getIsAdmin() {
		return isAdmin;
	}

	public void setIsAdmin(int isAdmin) {
		this.isAdmin = isAdmin;
	}

	public int getUid() {
		return uid;
	}

	public void setUid(int uid) {
		this.uid = uid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
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

	public String getPhonenumber() {
		return phonenumber;
	}

	public void setPhonenumber(String phonenumber) {
		this.phonenumber = phonenumber;
	}
	public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

}
