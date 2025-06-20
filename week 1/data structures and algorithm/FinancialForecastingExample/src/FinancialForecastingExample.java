public class FinancialForecastingExample {
    public static void main(String[] args) {
        double initialValue = 1000.0;
        double growthRate = 0.05; // 5% per period
        int periods = 10;

        double recursiveResult = FinancialForecast.futureValueRecursive(initialValue, growthRate, periods);
        double iterativeResult = FinancialForecast.futureValueIterative(initialValue, growthRate, periods);

        System.out.printf("Recursive Future Value after %d periods: %.2f\n", periods, recursiveResult);
        System.out.printf("Iterative Future Value after %d periods: %.2f\n", periods, iterativeResult);

        System.out.println("\n--- Recursion Concept ---");
        System.out.println("Recursion is when a method calls itself to solve smaller instances of a problem. It can simplify code for problems with repetitive structure, like this forecasting formula.");

        System.out.println("\n--- Time Complexity Analysis ---");
        System.out.println("The recursive algorithm has O(n) time complexity, where n is the number of periods. Each call reduces the problem by one period.");

        System.out.println("\n--- Optimization ---");
        System.out.println("Recursion can lead to stack overflow for large n. Iterative or closed-form solutions (like initialValue * (1 + growthRate)^periods) are preferred for performance and to avoid excessive computation.");
    }
} 