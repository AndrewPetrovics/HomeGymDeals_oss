import 'package:flutter/material.dart';
import 'package:home_gym_deals/services/TrackingSvc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/Home/HomeView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: "",
    anonKey:
        "",
  );
  await TrackingSvc.init();
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Gym Deals',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        
      ),
      //home: const HomeView(),
      routes: {
        "/": (context) => HomeView(),
      },
      onGenerateRoute: (settings) {
        var view = HomeView();
        if (settings.name != null) {
          var uriData = Uri.parse(settings.name!);
          var queryParams = uriData.queryParameters;
          switch (uriData.path) {
            case '/':
              view = HomeView();
              break;
          }
        }
        return MaterialPageRoute(builder: (BuildContext context) => view);
      },
    );
  }
}
