# FinancialForecastingExample

This project demonstrates a recursive algorithm for financial forecasting, predicting future values based on past data and growth rates.

## 1. Understanding Recursive Algorithms
Recursion is a programming technique where a method calls itself to solve smaller instances of a problem. It simplifies problems that have a repetitive or self-similar structure, such as calculating future values over multiple periods.

## 2. Setup
- `FinancialForecast.java`: Contains a recursive method to calculate future value given an initial value, growth rate, and number of periods.

## 3. Implementation
- `futureValueRecursive`: Recursively computes the future value using the formula:
  - `futureValueRecursive(initial, rate, n) = futureValueRecursive(initial, rate, n-1) * (1 + rate)`
  - Base case: if `n == 0`, return `initial`.
- Also includes an iterative version for optimization.

## 4. Analysis
- **Time Complexity**: The recursive algorithm has O(n) time complexity, where n is the number of periods. Each call reduces the problem by one period.
- **Optimization**: Recursion can cause stack overflow for large n. Use iteration or a closed-form formula (`initial * Math.pow(1 + rate, n)`) for better performance and to avoid excessive computation.

## 5. How to Compile and Run
1. Open a terminal and navigate to `FinancialForecastingExample/src`.
2. Compile all Java files:
   ```
   javac *.java
   ```
3. Run the main class:
   ```
   java FinancialForecastingExample
   ```

You will see the results of both recursive and iterative forecasting, as well as explanations and analysis. 