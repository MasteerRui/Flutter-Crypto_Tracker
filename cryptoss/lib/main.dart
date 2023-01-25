import 'package:another_flushbar/flushbar.dart';
import 'package:cryptoss/firebase_options.dart';
import 'package:cryptoss/firsttime_check.dart';
import 'package:cryptoss/pages/main_pages/homepage.dart';
import 'package:cryptoss/provider/dark_theme_provider.dart';
import 'package:cryptoss/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cryptoss/provider/firebase_auth_methods.dart';
import 'package:sizer/sizer.dart';

// Pages
import 'pages/auth_pages/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<FirebaseAuthMethods>(
            create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<FirebaseAuthMethods>().authState,
            initialData: null,
          ),
          ChangeNotifierProvider(create: (_) {
            return themeChangeProvider;
          }),
        ],
        child: Consumer<DarkThemeProvider>(builder: (
          context,
          themeData,
          child,
        ) {
          return Sizer(builder: (context, orientation, deviceType) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const FirstTimeCheckPage(),
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            );
          });
        }));
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const HomePage();
    }
    return const LoginPage();
  }
}
