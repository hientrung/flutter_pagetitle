## Features

The widget used to update application title when it created, disposed, or rebuild

Can be used with multiple/nested PageTitle and the latest one used to update application title

## Examples

```dart
PageTitle(
    title: 'Page title',
    child: const Other(),
);
```

```dart
MaterialApp(
    onGenerateTitle: (context) => PageTitle.current(context) ?? 'My App',
    //other config
);
```