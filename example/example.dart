import 'package:flutter/material.dart';
import 'package:pagetitle/pagetitle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/test': (context) => const Page(title: 'Test Page'),
      },
      onGenerateTitle: (context) => PageTitle.current(context) ?? 'My App',
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTitle(
        title: title,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Go back!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTitle(
        title: 'Home Page',
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/test');
            },
            child: const Text('Test page'),
          ),
        ),
      ),
    );
  }
}
