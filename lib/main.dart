import 'package:campus_subsystem/messaging/conversation_screen.dart';
import 'package:campus_subsystem/redux/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:campus_subsystem/faculty/faculty_login.dart';
import 'package:campus_subsystem/login_page.dart';
import 'package:campus_subsystem/student/student_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'firebase/notification.dart';
import 'firebase/signIn.dart';
import 'firebase/wrapper.dart';
import 'firebase_options.dart';
import 'loading_page.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

void main() async {
  int id = 0;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // notification permissions
  FlutterLocalNotificationsPlugin().initialize(const InitializationSettings(
    android: AndroidInitializationSettings("notification_icon"),
  ));

  // listen notification on foreground
  FirebaseMessaging.onMessage.listen((event) {
    id += 1;
    Map data = event.toMap();
    NotificationAPI.postLocalNotification(
        id: id,
        title: data["notification"]['title'],
        message: data["notification"]['body'],
        image: data["notification"]['image']);
  });

  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Navigator.of(context).pushNamed("chat_screen");
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: StreamProvider<User?>.value(
          value: Auth().user,
          initialData: null,
          child: MaterialApp(
            theme: ThemeData(fontFamily: "Muli"),
            color: Colors.transparent,
            debugShowCheckedModeBanner: false,
            initialRoute: 'loading_page',
            routes: {
              '/': (context) => const Wrapper(),
              'loading_page': (context) =>
                  LoadingPage(email: Auth().auth.currentUser?.email),
              'login_page': (context) => const Login(),
              't_login_form': (context) =>
                  const KeyboardVisibilityProvider(child: FacultyLogin()),
              's_login_form': (context) =>
                  const KeyboardVisibilityProvider(child: StudentLogin()),
              'chat_screen': (context) => const ConversationScreen(
                    isFaculty: false,
                  )
            },
          ),
        ));
  }
}
