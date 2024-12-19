# PageTitle

A Flutter widget to dynamically update the application title.

This package provides a simple way to manage the title displayed in the application switcher (recent apps list).  It handles nested titles and ensures that the title of the most recently displayed page is always used.

## Usage

Wrap any widget that represents a new "page" or "screen" with the `PageTitle` widget, providing the desired title for that page.

```dart
PageTitle(
  title: 'Home Page',
  child: Scaffold(
    appBar: AppBar(title: Text('Home')),
    body: Center(
      child: PageTitle(
        title: 'Product Details',
        child: Text('Product details'),
      ),
    ),
  ),
);
```

In this example, the application title will initially be "Home Page". When the user navigates to the product details, the title will change to "Product Details". When the user navigates back to the home page, the title will revert to "Home Page".

## Nested Titles

The PageTitle widget supports nested usage. The title of the most recently built PageTitle widget will be used as the application's title. This makes it easy to manage titles in complex navigation hierarchies.

## Accessing the Current Title

You can access the current title using the PageTitle.current static method:

```dart
String? currentTitle = PageTitle.current(context);
```

## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  page_title: ^latest_version
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

MIT License