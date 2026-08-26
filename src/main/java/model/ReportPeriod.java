package model;

import java.time.LocalDate;
import java.time.YearMonth;

public final class ReportPeriod {
    public static final String MONTH = "month";
    public static final String SIX_MONTHS = "six_months";
    public static final String YEAR = "year";

    private final String type;
    private final int month;
    private final int year;
    private final LocalDate startDate;
    private final LocalDate endDateExclusive;
    private final String displayLabel;
    private final String fileLabel;

    private ReportPeriod(String type, int month, int year, LocalDate startDate,
                         LocalDate endDateExclusive, String displayLabel, String fileLabel) {
        this.type = type;
        this.month = month;
        this.year = year;
        this.startDate = startDate;
        this.endDateExclusive = endDateExclusive;
        this.displayLabel = displayLabel;
        this.fileLabel = fileLabel;
    }

    public static ReportPeriod fromParameters(String typeValue, String monthValue, String yearValue) {
        LocalDate today = LocalDate.now();
        int month = parseBounded(monthValue, today.getMonthValue(), 1, 12);
        int year = parseBounded(yearValue, today.getYear(), 2000, today.getYear() + 1);
        String type = SIX_MONTHS.equals(typeValue) || YEAR.equals(typeValue) ? typeValue : MONTH;

        YearMonth selectedMonth = YearMonth.of(year, month);
        if (YEAR.equals(type)) {
            LocalDate start = LocalDate.of(year, 1, 1);
            return new ReportPeriod(type, month, year, start, start.plusYears(1),
                    "Năm " + year, "Nam_" + year);
        }
        if (SIX_MONTHS.equals(type)) {
            YearMonth firstMonth = selectedMonth.minusMonths(5);
            LocalDate start = firstMonth.atDay(1);
            LocalDate end = selectedMonth.plusMonths(1).atDay(1);
            String label = "6 tháng: " + firstMonth.getMonthValue() + "/" + firstMonth.getYear()
                    + " – " + selectedMonth.getMonthValue() + "/" + selectedMonth.getYear();
            return new ReportPeriod(type, month, year, start, end, label,
                    "6Thang_den_" + month + "-" + year);
        }

        LocalDate start = selectedMonth.atDay(1);
        return new ReportPeriod(type, month, year, start, selectedMonth.plusMonths(1).atDay(1),
                "Tháng " + month + "/" + year, "Thang_" + month + "-" + year);
    }

    private static int parseBounded(String rawValue, int fallback, int minimum, int maximum) {
        try {
            int parsed = Integer.parseInt(rawValue);
            return Math.max(minimum, Math.min(maximum, parsed));
        } catch (Exception ignored) {
            return fallback;
        }
    }

    public String getType() { return type; }
    public int getMonth() { return month; }
    public int getYear() { return year; }
    public LocalDate getStartDate() { return startDate; }
    public LocalDate getEndDateExclusive() { return endDateExclusive; }
    public LocalDate getEndDateInclusive() { return endDateExclusive.minusDays(1); }
    public String getDisplayLabel() { return displayLabel; }
    public String getFileLabel() { return fileLabel; }
}
