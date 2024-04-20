import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:practice/Providers/user_provider.dart';
import 'package:practice/Screens/chat_page.dart';
import 'package:practice/Screens/chatting_page.dart';
import 'package:practice/color.dart';
import 'package:practice/resources/local_notification.dart';
import 'package:practice/resources/message_service.dart';
import 'package:practice/responsive/things2.dart';
import 'Login and Signup/things.dart';
import 'responsive/things1.dart';
import 'mobilelayout.dart';
import 'weblayout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  await Firebase.initializeApp();
  await PushNotificationService().initialize();
  LocalNotification().initNotification();
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
        navigatorKey: navigatorKey,
        routes: {'/chat_page': (context) => const Chat()},
      ),
    );
  }
}
