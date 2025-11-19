package model;

public class cartItem {
	public int Ciid;
	public int pid;
	public int quantyti;
	public cartItem(int ciid, int pid, int quantyti) {
		super();
		Ciid = ciid;
		this.pid = pid;
		this.quantyti = quantyti;
	}
	public int getCiid() {
		return Ciid;
	}
	public void setCiid(int ciid) {
		Ciid = ciid;
	}
	public int getPid() {
		return pid;
	}
	public void setPid(int pid) {
		this.pid = pid;
	}
	public int getQuantyti() {
		return quantyti;
	}
	public void setQuantyti(int quantyti) {
		this.quantyti = quantyti;
	}
	

}
