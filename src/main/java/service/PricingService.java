package service;

import model.Voucher;

public final class PricingService {
    private PricingService() {
    }

    public static Quote calculate(double subtotal, Voucher voucher, double memberDiscountPercent) {
        double safeSubtotal = Math.max(0, subtotal);
        double safeMemberPercent = Math.max(0, Math.min(memberDiscountPercent, 100));
        double memberDiscount = safeSubtotal * safeMemberPercent / 100.0;
        double afterMemberDiscount = Math.max(0, safeSubtotal - memberDiscount);

        double voucherDiscount = 0;
        if (voucher != null && safeSubtotal >= voucher.getMinOrder()) {
            if ("PERCENT".equalsIgnoreCase(voucher.getDiscountType())) {
                double percent = Math.max(0, Math.min(voucher.getDiscountAmount(), 100));
                voucherDiscount = afterMemberDiscount * percent / 100.0;
            } else if ("FIXED".equalsIgnoreCase(voucher.getDiscountType())) {
                voucherDiscount = Math.max(0, voucher.getDiscountAmount());
            }
        }
        voucherDiscount = Math.min(voucherDiscount, afterMemberDiscount);

        return new Quote(
                safeSubtotal,
                memberDiscount,
                voucherDiscount,
                Math.max(0, afterMemberDiscount - voucherDiscount),
                safeMemberPercent);
    }

    public static final class Quote {
        private final double subtotal;
        private final double memberDiscount;
        private final double voucherDiscount;
        private final double finalTotal;
        private final double memberDiscountPercent;

        private Quote(double subtotal, double memberDiscount, double voucherDiscount, double finalTotal,
                double memberDiscountPercent) {
            this.subtotal = subtotal;
            this.memberDiscount = memberDiscount;
            this.voucherDiscount = voucherDiscount;
            this.finalTotal = finalTotal;
            this.memberDiscountPercent = memberDiscountPercent;
        }

        public double getSubtotal() {
            return subtotal;
        }

        public double getMemberDiscount() {
            return memberDiscount;
        }

        public double getVoucherDiscount() {
            return voucherDiscount;
        }

        public double getTotalDiscount() {
            return memberDiscount + voucherDiscount;
        }

        public double getFinalTotal() {
            return finalTotal;
        }

        public double getMemberDiscountPercent() {
            return memberDiscountPercent;
        }
    }
}
