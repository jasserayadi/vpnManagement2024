import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpn_management/providers/client_provider.dart';
import 'package:vpn_management/providers/VpnProvider.dart';
import 'package:vpn_management/screens/clientListScreen.dart';
import 'package:vpn_management/screens/clientForm.dart';
import 'package:vpn_management/screens/login_screen.dart';
import 'package:vpn_management/screens/register_screen.dart';
import 'package:vpn_management/screens/vpnListScreen.dart'; // Import the VpnListScreen
import 'package:vpn_management/screens/vpnFormScreen.dart'; // Import the VpnFormScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClientProvider()),
        ChangeNotifierProvider(create: (context) => VpnProvider()), // Add VpnProvider here
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          
        ),
        initialRoute: '/login',
        routes: {
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/clients': (context) => ClientListScreen(),
          '/create-client': (context) => ClientForm(),
        /*  '/create-vpn': (context) =>  VpnFormScreen(clientId: clientId1),*/
          '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/vpn-list') {
            final clientId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) {
                return VpnListScreen(clientId: clientId);
              },
            );
          }
          return null;
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
