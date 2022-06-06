import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mystore/repository/dummy_remote_repository.dart';
import 'package:mystore/ui/page/store_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DummyRemoteRepository(),
      child: MaterialApp(
        title: 'MyStore',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          primaryColor: Colors.deepOrangeAccent,
          fontFamily: 'Quicksand',
          textTheme: const TextTheme(
            titleSmall: TextStyle(color: Colors.white),
            titleMedium: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
          ),
        ),
        home: const StorePageProvider(),
      ),
    );
  }
}
