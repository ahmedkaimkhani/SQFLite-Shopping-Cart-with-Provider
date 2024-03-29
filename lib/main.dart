import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_shopping_cart_with_provider/cart_provider.dart';
import 'package:sqflite_shopping_cart_with_provider/product_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const ProductListScreen(),
          );
        },
      ),
    );
  }
}
