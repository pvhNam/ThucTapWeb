package model;

import java.util.List;

public class StockImportLine {
    private final int productId;
    private final List<String> colors;
    private final List<String> sizes;
    private final int quantityPerVariant;
    private final double unitCost;

    public StockImportLine(int productId, List<String> colors, List<String> sizes,
            int quantityPerVariant, double unitCost) {
        this.productId = productId;
        this.colors = List.copyOf(colors);
        this.sizes = List.copyOf(sizes);
        this.quantityPerVariant = quantityPerVariant;
        this.unitCost = unitCost;
    }

    public int getProductId() { return productId; }
    public List<String> getColors() { return colors; }
    public List<String> getSizes() { return sizes; }
    public int getQuantityPerVariant() { return quantityPerVariant; }
    public double getUnitCost() { return unitCost; }
    public int getVariantCount() { return colors.size() * sizes.size(); }
    public int getTotalQuantity() { return getVariantCount() * quantityPerVariant; }
    public double getTotalCost() { return getTotalQuantity() * unitCost; }
}
