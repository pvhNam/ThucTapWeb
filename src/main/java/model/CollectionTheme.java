package model;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;

/** Editorial collections are independent of product categories. */
public enum CollectionTheme {
    AUTUMN_WINTER("autumn-winter", "Thu đông", "Autumn / Winter", "Ấm áp trong từng lớp phối.", "A warmer take on everyday layers.", "fa-leaf"),
    SUMMER("summer", "Summer", "Summer", "Nhẹ nhàng đón những ngày nắng.", "Light pieces for sun-filled days.", "fa-sun"),
    PARTY("party", "Tiệc", "Party", "Một chút nổi bật cho dịp đặc biệt.", "Make an entrance on special occasions.", "fa-champagne-glasses"),
    BEACH("beach", "Bãi biển", "Beach", "Mang tinh thần kỳ nghỉ vào tủ đồ.", "Bring a little holiday into your wardrobe.", "fa-umbrella-beach"),
    OFFICE("office", "Công sở", "Office", "Chỉn chu, tự tin mỗi ngày đi làm.", "Considered style for your working week.", "fa-briefcase");

    private final String slug;
    private final String nameVi;
    private final String nameEn;
    private final String descriptionVi;
    private final String descriptionEn;
    private final String icon;

    CollectionTheme(String slug, String nameVi, String nameEn, String descriptionVi, String descriptionEn, String icon) {
        this.slug = slug;
        this.nameVi = nameVi;
        this.nameEn = nameEn;
        this.descriptionVi = descriptionVi;
        this.descriptionEn = descriptionEn;
        this.icon = icon;
    }

    public String getSlug() { return slug; }
    public String getNameVi() { return nameVi; }
    public String getNameEn() { return nameEn; }
    public String getDescriptionVi() { return descriptionVi; }
    public String getDescriptionEn() { return descriptionEn; }
    public String getIcon() { return icon; }
    public static List<CollectionTheme> all() { return List.of(values()); }

    public static CollectionTheme fromSlug(String slug) {
        if (slug == null) return null;
        String normalized = slug.trim().toLowerCase(Locale.ROOT);
        return Arrays.stream(values()).filter(theme -> theme.slug.equals(normalized)).findFirst().orElse(null);
    }
}
