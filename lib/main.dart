import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ApoTrack App',
      theme: ThemeData(
        colorScheme:ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Get Location',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:Color.deepGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Get Location'),
    );
  }
}

class MyHomePage extend StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const LocationWidget(),
    );
  }
}

class LocationWidget extends StatefulWidget{
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String _locationMessage = "";
  Position? _currentPosition;

  void _getCurrentLocation() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      final result = await Permission.location.status;
      if (result != PermissionStatus.granted) {
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
    setState(() {
    _currentPosition = position;
    _locationMessage = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
    });
  }

  Future<void> _showOnMap() async {
    if(_currentPosition != null) {
      Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},'
      '${_currentPosition!.longitude}');

      try {
        await launchUrl(googleMapsUrl);
      } catch (e) {
        throw 'Could not launch $googleMapsUrl';
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(_locationMessage),
      const  SizedBox(height:10,),
      ElevatedButton(
        onPressed: _getCurrentLocation,
        child: const Text('Get Location'),
      ),
      const SizedBox(height:10,),
      if( currentPosition != null)
        ElevatedButton(
          onPressed: _showOnMap,
          child: const Text('Show on Map'),
        ),
    ],
    ),
    );
}
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    NearbyPharmaciesScreen(),
    SearchMapScreen(),
    ConsultationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Apotrack!'),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.local_pharmacy),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Map'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Consultation'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Consultation',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}

class NearbyPharmaciesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Daftar Apotek Terdekat',
        style: TextStyle(fontSize: 24, color: Colors.teal),
      ),
    );
  }
}

class SearchMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Hasil Pencarian Map',
        style: TextStyle(fontSize: 24, color: Colors.teal),
      ),
    );
  }
}

class ConsultationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Konsultasi',
        style: TextStyle(fontSize: 24, color: Colors.teal),
      ),
    );
  }
}