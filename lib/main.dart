import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/services.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/color.dart';
import 'package:practice/responsive/things2.dart';
import 'Login and Signup/things.dart';
import 'responsive/things1.dart';
import 'mobilelayout.dart';
import 'weblayout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  await Firebase.initializeApp();
  runApp(Xenon());
}

class Xenon extends StatelessWidget {
  const Xenon({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Xenon",
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Palette.scaffold,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const Responsive(
                  mobileBody: MobileLayout(),
                  desktopBody: WebLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }
            return const Login();
          },
        ),
      ),
    );
  }
}
