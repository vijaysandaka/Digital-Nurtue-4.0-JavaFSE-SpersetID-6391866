public class FinancialForecast {
    /**
     * Recursively calculates the future value.
     * @param initialValue The starting value
     * @param growthRate The growth rate per period (e.g., 0.05 for 5%)
     * @param periods Number of periods to forecast
     * @return The forecasted future value
     */
    public static double futureValueRecursive(double initialValue, double growthRate, int periods) {
        if (periods == 0) {
            return initialValue;
        }
        return futureValueRecursive(initialValue, growthRate, periods - 1) * (1 + growthRate);
    }

    /**
     * Optimized version using iteration (to avoid recursion overhead)
     */
    public static double futureValueIterative(double initialValue, double growthRate, int periods) {
        double value = initialValue;
        for (int i = 0; i < periods; i++) {
            value *= (1 + growthRate);
        }
        return value;
    }
} 