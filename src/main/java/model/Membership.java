package model;

public class Membership {
    public static final String STANDARD = "STANDARD";
    public static final String BRONZE = "BRONZE";
    public static final String SILVER = "SILVER";
    public static final String GOLD = "GOLD";
    public static final String DIAMOND = "DIAMOND";

    private final int userId;
    private final String tier;
    private final double lifetimeSpend;
    private final double discountPercent;

    public Membership(int userId, String tier, double lifetimeSpend, double discountPercent) {
        this.userId = userId;
        this.tier = tier == null || tier.isBlank() ? STANDARD : tier;
        this.lifetimeSpend = Math.max(0, lifetimeSpend);
        this.discountPercent = Math.max(0, discountPercent);
    }

    public static Membership standard(int userId) {
        return new Membership(userId, STANDARD, 0, 0);
    }

    public int getUserId() {
        return userId;
    }

    public String getTier() {
        return tier;
    }

    public String getTierLabel() {
        return switch (tier) {
            case BRONZE -> "Đồng";
            case SILVER -> "Bạc";
            case GOLD -> "Vàng";
            case DIAMOND -> "Kim Cương";
            default -> "Thường";
        };
    }

    public double getLifetimeSpend() {
        return lifetimeSpend;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public boolean isMember() {
        return discountPercent > 0;
    }
}
