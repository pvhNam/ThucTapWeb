package dao;

import model.product;
import model.cartItem;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class DataStore {
    // 1. DANH SÁCH SẢN PHẨM
    public static List<product> listProduct = new ArrayList<>();
    
    // 2. GIỎ HÀNG NGƯỜI DÙNG
    public static Map<Integer, List<cartItem>> userCarts = new HashMap<>();

    static {
        // --- SẢN PHẨM MẪU (12 CÁI ĐỂ HIỆN THÀNH 3-4 HÀNG) ---
        
        // 1. Nhóm Năng động
        listProduct.add(new product(1, "Street Style Năng Động", 500000.0, 1, "Đen", "L", 50, "img/maunangdong.jpg"));
        listProduct.add(new product(2, "Áo Hoodie Oversize", 650000.0, 1, "Xám", "XL", 20, "img/maunangdong.jpg"));
        listProduct.add(new product(3, "Quần Jogger Kaki", 450000.0, 1, "Be", "M", 35, "img/maunangdong.jpg"));
        listProduct.add(new product(4, "Áo Thun Graphic Tee", 350000.0, 1, "Trắng", "L", 60, "img/maunangdong.jpg"));

        // 2. Nhóm Công sở
        listProduct.add(new product(5, "Công Sở Thanh Lịch", 750000.0, 2, "Trắng", "M", 30, "img/congso.jpg"));
        listProduct.add(new product(6, "Vest Nam Xanh Navy", 1500000.0, 2, "Xanh", "L", 15, "img/congso.jpg"));
        listProduct.add(new product(7, "Quần Tây Slimfit", 550000.0, 2, "Đen", "32", 40, "img/congso.jpg"));
        listProduct.add(new product(8, "Sơ Mi Oxford Blue", 480000.0, 2, "Xanh Nhạt", "M", 25, "img/congso.jpg"));

        // 3. Nhóm Dạ hội / Sang trọng
        listProduct.add(new product(9, "Dạ Hội Quý Phái", 1200000.0, 3, "Đỏ", "S", 15, "img/dangcap.jpg"));
        listProduct.add(new product(10, "Váy Lụa Satin", 950000.0, 3, "Vàng Kim", "S", 10, "img/dangcap.jpg"));
        listProduct.add(new product(11, "Đầm Maxi Dự Tiệc", 1800000.0, 3, "Đen Tuyền", "M", 8, "img/dangcap.jpg"));
        listProduct.add(new product(12, "Suit Tuxedo Cao Cấp", 2500000.0, 3, "Đen", "L", 5, "img/dangcap.jpg"));
    }

    // --- CÁC HÀM HỖ TRỢ (GIỮ NGUYÊN) ---

    public static product getProductById(int pid) {
        for (product p : listProduct) {
            if (p.getPid() == pid) return p;
        }
        return null;
    }

    public static void addItemToUserCart(int uid, int pid, int quantity) {
        List<cartItem> items = userCarts.getOrDefault(uid, new ArrayList<>());
        boolean exists = false;
        for (cartItem item : items) {
            if (item.getPid() == pid) {
                item.setQuantyti(item.getQuantyti() + quantity);
                exists = true;
                break;
            }
        }
        if (!exists) {
            int newCiid = items.size() + 1; 
            items.add(new cartItem(newCiid, pid, quantity));
        }
        userCarts.put(uid, items);
    }

    public static List<cartItem> getUserCart(int uid) {
        return userCarts.getOrDefault(uid, new ArrayList<>());
    }

    public static void removeUserCartItem(int uid, int pid) {
        List<cartItem> items = userCarts.get(uid);
        if (items != null) {
            items.removeIf(item -> item.getPid() == pid);
        }
    }
}