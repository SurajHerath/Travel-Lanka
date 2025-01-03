import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_lanka/controller/ThemeController.dart';
import 'package:travel_lanka/view/CurrencyConverterPage.dart';
import 'package:travel_lanka/view/AboutPage.dart';
import 'package:travel_lanka/view/SignPage.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onNavigate;
  final int currentIndex;
  final String userName;
  final String email;

  const CustomDrawer({
    Key? key,
    required this.onNavigate,
    required this.currentIndex,
    required this.userName,
    required this.email,
  }) : super(key: key);

  Future<void> logout(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You have logged out.")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage('https://placehold.co/600x400'),
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: currentIndex == 0,
            onTap: () {
              Navigator.pop(context);
              onNavigate(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            selected: currentIndex == 1,
            onTap: () {
              Navigator.pop(context);
              onNavigate(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Trips'),
            selected: currentIndex == 2,
            onTap: () {
              Navigator.pop(context);
              onNavigate(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on_sharp),
            title: const Text('Place'),
            selected: currentIndex == 3,
            onTap: () {
              Navigator.pop(context);
              onNavigate(3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Currency Converter'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CurrencyConverterPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            title: Text(
              themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
            ),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              logout(context);
            },
          ),
        ],
      ),
    );
  }
}

