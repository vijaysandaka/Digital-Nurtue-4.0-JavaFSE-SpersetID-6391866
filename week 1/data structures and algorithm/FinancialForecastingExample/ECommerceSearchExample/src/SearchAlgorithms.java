import java.util.Arrays;
import java.util.Comparator;

public class SearchAlgorithms {
    // Linear search by productId
    public static Product linearSearch(Product[] products, int productId) {
        for (Product product : products) {
            if (product.getProductId() == productId) {
                return product;
            }
        }
        return null;
    }

    // Binary search by productId (array must be sorted by productId)
    public static Product binarySearch(Product[] products, int productId) {
        int left = 0, right = products.length - 1;
        while (left <= right) {
            int mid = left + (right - left) / 2;
            if (products[mid].getProductId() == productId) {
                return products[mid];
            } else if (products[mid].getProductId() < productId) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return null;
    }

    // Utility to sort products by productId
    public static void sortProductsById(Product[] products) {
        Arrays.sort(products, Comparator.comparingInt(Product::getProductId));
    }
} 