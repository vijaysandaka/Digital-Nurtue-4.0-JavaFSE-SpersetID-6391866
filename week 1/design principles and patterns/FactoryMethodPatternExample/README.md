# FactoryMethodPatternExample

This project demonstrates the Factory Method Pattern in Java for creating different types of documents (Word, PDF, Excel).

## Structure
- `Document.java`: Interface for documents
- `WordDocument.java`, `PdfDocument.java`, `ExcelDocument.java`: Concrete document classes
- `DocumentFactory.java`: Abstract factory class
- `WordDocumentFactory.java`, `PdfDocumentFactory.java`, `ExcelDocumentFactory.java`: Concrete factories
- `FactoryMethodPatternExample.java`: Main class to demonstrate usage

## How to Compile and Run

1. Open a terminal and navigate to the `FactoryMethodPatternExample/src` directory.
2. Compile all Java files:
   ```
   javac *.java
   ```
3. Run the main class:
   ```
   java FactoryMethodPatternExample
   ```

You should see output for opening and saving Word, PDF, and Excel documents. 