import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_lanka/services/FirebaseService.dart';
import 'package:travel_lanka/controller/ThemeController.dart';
import 'package:travel_lanka/view/SignPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Travel Lanka',
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.redAccent[700],
            scaffoldBackgroundColor: Colors.white,
            cardColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.redAccent[700],
              foregroundColor: Colors.white,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.redAccent[700],
              unselectedItemColor: Colors.grey,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.redAccent[700],
            scaffoldBackgroundColor: Colors.grey[900],
            cardColor: Colors.grey[850],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900],
              foregroundColor: Colors.white,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.grey[900],
              selectedItemColor: Colors.redAccent[700],
              unselectedItemColor: Colors.grey,
            ),
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const SignPage(),
        );
      },
    );
  }
}

