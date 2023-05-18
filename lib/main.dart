import 'dart:async';
import 'package:campus_subsystem/messaging/conversation_screen.dart';
import 'package:campus_subsystem/redux/store.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays:
        SystemUiOverlay.values, //This line is used for showing the bottom bar
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
  //   // Or Brightness.dark
  // );

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print("wwwwwwwwwwwwwwwwwwwww${e.toString()}");
  }

  // notification permissions
  FlutterLocalNotificationsPlugin().initialize(const InitializationSettings(
    android: AndroidInitializationSettings("notification_icon"),
  ));

  runApp(StoreProvider(
      store: store,
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Muli"),
        color: Colors.transparent,
        debugShowCheckedModeBanner: false,
        initialRoute: 'loading_page',
        routes: {
          '/': (context) => const Main(),
          'loading_page': (context) =>
              LoadingPage(email: Auth().auth.currentUser?.email),
          // 'login_page': (context) => const Login(),
          // 't_login_form': (context) =>
          // const KeyboardVisibilityProvider(child: FacultyLogin()),
          // 's_login_form': (context) =>
          // const KeyboardVisibilityProvider(child: StudentLogin()),
          'chat_screen': (context) => const ConversationScreen(
                isFaculty: false,
              )
        },
      )));
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with WidgetsBindingObserver {
  late ConnectivityResult _previous;
  late StreamSubscription internet;
  bool isinternet = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    print("${state.index}   ${state.name}");

    switch (state.index) {
      case 0:
        internet.resume();
        break;
      case 1:
      case 3:
      case 2:
        internet.pause();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    internet.cancel();
  }

  @override
  void initState() {
    int id = 0;
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    internet =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult event) {
      switch (event) {
        case ConnectivityResult.none:
          isinternet = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            elevation: 20,
            content: const Text("No Internet Connection"),
            // duration: Duration(seconds: 10),
            action: SnackBarAction(
                label: "Try again",
                onPressed: () {
                  setState(() {});
                }),
          ));
          // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NoInternet()));
          break;
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          if (!isinternet) {
            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Internet")));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              elevation: 20,
              content: Text("Internet Connection is back"),
              // action: SnackBarAction(
              //     label: "Try again",
              //     onPressed: () {
              //       setState(() {});
              //     }),
            ));
          }
          // Navigator.of(context).ca

          break;
      }
    });

    // listen notification on foreground
    FirebaseMessaging.onMessage.listen((event) {
      id += 1;
      Map data = event.toMap();
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
    return ChangeNotifierProvider(
        create: (context) => Auth(), child: const Wrapper());
  }

  showAlert(BuildContext context, Map data) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            alignment: Alignment.center,
            title: Text(data["notification"]['title']),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["notification"]['body'],
                    maxLines: 9,
                  ),
                  data["data"]["image"].isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(data["data"]["image"])),
                              shape: BoxShape.circle),
                        )
                      : Container(),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurpleAccent),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)))),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"))
            ],
          );
        });
  }
}
