import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_lanka/controller/FavoriteController.dart';
import 'package:travel_lanka/view/HomePage.dart';
import 'package:travel_lanka/view/FavoritesPage.dart';
import 'package:travel_lanka/view/ViewTripsPage.dart';
import 'package:travel_lanka/view/ViewPlacePage.dart';
import 'package:travel_lanka/widget/CustomDrawer.dart';

class MainPage extends StatefulWidget {
  final String email;
  final String username;

  const MainPage({Key? key, required this.email, required this.username}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    // Create a single instance of FavoriteController to be shared
    final favoriteController = FavoriteController(email: widget.email);

    _pages = [
      // Wrap both HomePage and FavoritesPage with the same Provider instance
      ChangeNotifierProvider.value(
        value: favoriteController,
        child: const HomePage(),
      ),
      ChangeNotifierProvider.value(
        value: favoriteController,
        child: FavoritesPage(email: widget.email),
      ),
      ViewTripsPage(email: widget.email),
      ViewPlacePage(email: widget.email),
    ];
  }

  void _onNavigate(int index) {
    if (widget.username == 'Guest' && index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feature unavailable for Guest user")),
      );
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Travel Lanka',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: CustomDrawer(
        onNavigate: _onNavigate,
        currentIndex: _currentIndex,
        userName: widget.username,
        email: widget.email,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigate,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: widget.username == 'Guest' ? 'Disabled' : 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: widget.username == 'Guest' ? 'Disabled' : 'Trip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_sharp),
            label: widget.username == 'Guest' ? 'Disabled' : 'Place',
          ),
        ],
        selectedItemColor: widget.username == 'Guest' ? Colors.grey: Colors.redAccent[700],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

