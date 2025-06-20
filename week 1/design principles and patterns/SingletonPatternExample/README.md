# SingletonPatternExample

This project demonstrates the Singleton design pattern in Java with a Logger utility class.

## Structure
- `src/Logger.java`: The Singleton Logger class.
- `src/LoggerTest.java`: Test class to verify the Singleton behavior.

## How to Compile and Run

1. Open a terminal and navigate to the `SingletonPatternExample` directory.
2. Compile the Java files:
   ```
   javac -d bin src/Logger.java src/LoggerTest.java
   ```
   (If the `bin` directory does not exist, create it first: `mkdir bin`)
3. Run the test:
   ```
   java -cp bin LoggerTest
   ```

## Expected Output
```
Both logger1 and logger2 are the same instance.
LOG: This is a test log message.
LOG: This is another test log message.
``` 