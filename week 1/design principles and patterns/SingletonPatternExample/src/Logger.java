public class Logger {
    private static Logger instance;

    // Private constructor to prevent instantiation
    private Logger() {
        // Optional: Initialize resources
    }

    // Public method to provide access to the instance
    public static Logger getInstance() {
        if (instance == null) {
            instance = new Logger();
        }
        return instance;
    }

    // Example logging method
    public void log(String message) {
        System.out.println("LOG: " + message);
    }
} 