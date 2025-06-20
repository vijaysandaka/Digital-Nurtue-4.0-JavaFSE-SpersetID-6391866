# ECommerceSearchExample

This project demonstrates linear and binary search algorithms for an e-commerce platform's product search, with time complexity analysis and discussion.

## 1. Big O Notation
Big O notation describes the upper bound of an algorithm's running time as the input size grows. It helps compare algorithms' efficiency and scalability.
- **Best Case**: The minimum time taken (e.g., first element match).
- **Average Case**: The expected time over all possible inputs.
- **Worst Case**: The maximum time taken (e.g., element not found).

## 2. Product Class
- `Product.java`: Contains `productId`, `productName`, and `category`.

## 3. Search Algorithms
- `SearchAlgorithms.java`: Implements linear and binary search for products by `productId`.

## 4. Analysis
- Linear Search: O(n) (Best: O(1), Average: O(n/2), Worst: O(n))
- Binary Search: O(log n) (Best: O(1), Average/Worst: O(log n)), requires sorted array
- Binary search is more suitable for large, sorted datasets due to its speed.

## 5. How to Compile and Run
1. Open a terminal and navigate to `ECommerceSearchExample/src`.
2. Compile all Java files:
   ```
   javac *.java
   ```
3. Run the main class:
   ```
   java ECommerceSearchExample
   ```

You will see the results of both search algorithms and a discussion of their time complexities. 