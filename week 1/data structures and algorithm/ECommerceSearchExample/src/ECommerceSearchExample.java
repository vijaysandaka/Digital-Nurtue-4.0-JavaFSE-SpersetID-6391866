public class ECommerceSearchExample {
    public static void main(String[] args) {
        // Sample products
        Product[] products = {
            new Product(3, "Laptop", "Electronics"),
            new Product(1, "Shirt", "Clothing"),
            new Product(5, "Book", "Books"),
            new Product(2, "Phone", "Electronics"),
            new Product(4, "Shoes", "Footwear")
        };

        int searchId = 4;
        System.out.println("Searching for productId: " + searchId);

        // Linear Search
        Product foundLinear = SearchAlgorithms.linearSearch(products, searchId);
        System.out.println("Linear Search Result: " + foundLinear);

        // Prepare for Binary Search
        SearchAlgorithms.sortProductsById(products);
        Product foundBinary = SearchAlgorithms.binarySearch(products, searchId);
        System.out.println("Binary Search Result: " + foundBinary);

        // Analysis
        System.out.println("\n--- Time Complexity Analysis ---");
        System.out.println("Linear Search: O(n) - Best: O(1), Average: O(n/2), Worst: O(n)");
        System.out.println("Binary Search: O(log n) - Best: O(1), Average/Worst: O(log n) (requires sorted array)");

        System.out.println("\n--- Discussion ---");
        System.out.println("Linear search is simple and works on unsorted data, but is slow for large datasets.");
        System.out.println("Binary search is much faster for large, sorted datasets, making it more suitable for e-commerce platforms where performance is critical.");
    }
} 