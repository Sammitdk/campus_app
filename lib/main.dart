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
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // notification permissions
  FlutterLocalNotificationsPlugin().initialize(const InitializationSettings(
    android: AndroidInitializationSettings("notification_icon"),
  ));

  runApp(StoreProvider(
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
            '/': (context) => const Main(),
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
      )));
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {


  @override
  void initState() {
    int id = 0;
    super.initState();

    // listen notification on foreground
    FirebaseMessaging.onMessage.listen((event) {
      id += 1;
      Map data = event.toMap();
      print(data["data"]["event"]);

      data["data"]["event"] != 'true'
          ? NotificationAPI.postLocalNotification(
              id: id,
              title: data["notification"]['title'],
              message: data["notification"]['body'],
              image: data["notification"]['image'])
          : showAlert(context, data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Navigator.of(context).pushNamed("chat_screen");
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Wrapper();
  }

  showAlert(BuildContext context,Map data) {
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)),
        alignment: Alignment.center,
        title: Text(data["notification"]['title']),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data["notification"]['body'],maxLines: 9,),
              // data["data"]["image"].isNotEmpty?Container(
              //   decoration: BoxDecoration(
              //     image: DecorationImage(image: NetworkImage(data["data"]["image"])),
              //     shape: BoxShape.circle
              //   ),
              // ):Container(),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)))
              ),
              onPressed: () => Navigator.of(context).pop(), child: const Text("OK"))
        ],
      );
    });
  }
}
