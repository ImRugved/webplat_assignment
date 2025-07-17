import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'provider/object_provider.dart';
import 'view/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ObjectProvider(),
      child: MaterialApp(
        title: 'Webplat',
        debugShowCheckedModeBanner: false,

        home: const SplashScreen(),
      ),
    );
  }
}
