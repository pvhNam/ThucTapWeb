package service;

import model.Membership;

public final class LoyaltyPolicy {
    public static final double BRONZE_THRESHOLD = 2_000_000d;
    public static final double SILVER_THRESHOLD = 5_000_000d;
    public static final double GOLD_THRESHOLD = 10_000_000d;
    public static final double DIAMOND_THRESHOLD = 20_000_000d;

    private LoyaltyPolicy() {
    }

    public static Membership membershipFor(int userId, double lifetimeSpend) {
        if (lifetimeSpend >= DIAMOND_THRESHOLD) {
            return new Membership(userId, Membership.DIAMOND, lifetimeSpend, 20);
        }
        if (lifetimeSpend >= GOLD_THRESHOLD) {
            return new Membership(userId, Membership.GOLD, lifetimeSpend, 15);
        }
        if (lifetimeSpend >= SILVER_THRESHOLD) {
            return new Membership(userId, Membership.SILVER, lifetimeSpend, 10);
        }
        if (lifetimeSpend >= BRONZE_THRESHOLD) {
            return new Membership(userId, Membership.BRONZE, lifetimeSpend, 5);
        }
        return new Membership(userId, Membership.STANDARD, lifetimeSpend, 0);
    }
}
