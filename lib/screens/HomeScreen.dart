import 'dart:async';
import 'package:flutter/material.dart';

// Define your AppRoutes here
class AppRoutes {
  static const String homeScreenInitialPage = '/login';
  static const String searchPage = '/login';
  static const String bookingCompletedPage = '/login';
}

// Main HomeScreen widget
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: _buildTopNavigationBar(context),
        ),
        resizeToAvoidBottomInset: false,
        body: Navigator(
          key: navigatorKey,
          initialRoute: AppRoutes.homeScreenInitialPage,
          onGenerateRoute: (routeSetting) {
            return PageRouteBuilder(
              pageBuilder: (ctx, ani, ani1) =>
                  getCurrentPage(routeSetting.name!),
              transitionDuration: const Duration(seconds: 0),
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildTopNavigationBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'assets/images-removebg-preview.png', 
            width: 100,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text('Login'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
              ),
              child: Text('Register'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: SizedBox(width: 50),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SRA Integration © 2024. Tous les droits réservés. Powered by SAME TEAM',
            style: TextStyle(color: Colors.white),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.facebook, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.homeScreenInitialPage:
        return HomeScreenInitialPage();
      case AppRoutes.searchPage:
        return SearchPage();
      case AppRoutes.bookingCompletedPage:
        return BookingCompletedPage();
      default:
        return DefaultWidget();
    }
  }
}

class HomeScreenInitialPage extends StatefulWidget {
  @override
  _HomeScreenInitialPageState createState() => _HomeScreenInitialPageState();
}

class _HomeScreenInitialPageState extends State<HomeScreenInitialPage> {
  String displayedText = '';
  final String fullText = 'Welcome to the Home Screen!';
  int currentIndex = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
      if (currentIndex < fullText.length) {
        setState(() {
          displayedText += fullText[currentIndex];
          currentIndex++;
        });
      } else {
        timer.cancel(); // Stop the timer when the text is fully displayed
      }
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Clean up the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/VPN.jpg', // Background image
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0), // Move text lower
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  displayedText,
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(115, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          'Search Page',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}

class BookingCompletedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          'Booking Completed Page',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}


class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          'Default Widget',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}

// Main function
void main() {
  runApp(MaterialApp(
    title: 'Your App Title',
    home: HomeScreen(),
  ));
}