# MarkdownPackage

The MarkdownPackage provides a robust solution for parsing and rendering Markdown content within your 
Swift projects. It includes a comprehensive set of tools for transforming Markdown text into various formats, 
including attributed strings, HTML, and PDF documents. This package is designed to be easily integrated into iOS, 
macOS, and other Swift-based applications.

## Features

	•	Markdown Parsing: Efficiently parses Markdown text to an intermediate representation, 
		enabling flexible rendering options.
	•	Attributed String Rendering: Converts Markdown to NSAttributedString, allowing for rich text 
		display in UIKit and AppKit components.
	•	HTML Conversion: Transforms Markdown into clean HTML code, suitable for web views or 
		exporting as web content.
	•	PDF Generation: Enables the creation of PDF documents from Markdown content, with support 
		for custom styling and layouts.
	•	Extensible Design: The package is designed with extensibility in mind, allowing developers 
		to add custom rendering or parsing rules to suit their specific needs.

## Components

	•	Lexer: Breaks down Markdown text into tokens for further processing.
	•	Parser: Converts tokens into a structured document model.
	•	Renderers:
	•	AttributedTextRenderer: Generates attributed strings for displaying in UI components.
	•	HTMLRenderer: Creates HTML content from Markdown.
	•	PDFRenderer: Produces PDF documents, with support for custom styles.

## Usage

To use the MarkdownPackage, add it as a dependency to your Swift project using Swift Package Manager. 
Then, import the package in your Swift files where you intend to parse or render Markdown content.

### Parsing Markdown

```Swift
import MarkdownPackage

let markdownText = "Your Markdown content here"
let lexer = Lexer()
let tokens = lexer.tokenize(markdownText)
let parser = Parser()
let document = parser.parse(tokens: tokens)
```

### Rendering to Attributed String

```Swift
let renderer = AttributedTextRenderer()
let attributedString = renderer.render(document)
// Use the attributedString in your UI components
```

### Converting to HTML

```Swift
let htmlRenderer = HTMLRenderer()
let htmlContent = htmlRenderer.render(document)
// Use the htmlContent in a web view or export as HTML file
```

### Generating PDF

```Swift
let pdfRenderer = PDFRenderer()
pdfRenderer.render(document, author: "Author Name", title: "Document Title") { pdfData in
    // Use the pdfData to save or share the PDF document
}
```
## Installation
### Swift Package Manager
Copy framework url to clipboard:

Copy the framework URL to your clipboard:

Open your project in Xcode and navigate to the “Frameworks, Libraries, and Embedded Content” 
section in the general project settings, then click on the add new library button:

Next, select “Add Other…” -> “Add Package Dependency…”:

In the pop-up window, paste the copied URL into the search bar and press the “Add Package” button:

In the package selection window, ensure the TaskManagerPackage is checked, then press “Add Package”:

## Contributing

Contributions to the MarkdownPackage are welcome. Whether it’s bug reports, feature requests, 
or contributions to code, please feel free to reach out or submit a pull request.

## License

The MarkdownPackage is released under the MIT License. See the LICENSE file for more details.
