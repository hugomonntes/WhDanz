import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Skip Firebase initialization for web demo
  // await Firebase.initializeApp();
  
  runApp(
    const ProviderScope(
      child: WhDanzApp(),
    ),
  );
}
