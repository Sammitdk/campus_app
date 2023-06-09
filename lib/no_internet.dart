import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    // InternetConnectionChecker().onStatusChange.listen((status) {
    //   switch (status) {
    //     case InternetConnectionStatus.connected:
    //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Wrapper()));
    //       break;
    //     case InternetConnectionStatus.disconnected:
    //       break;
    //   }
    // });
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: clicked
          ? FloatingActionButton(
              heroTag: null,
              onPressed: null,
              backgroundColor: Colors.indigo[300],
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : FloatingActionButton.extended(
              backgroundColor: Colors.indigo[300],
              foregroundColor: Colors.white,
              onPressed: () async {
                setState(() => clicked = true);
                if (await InternetConnectionChecker().connectionStatus.then((value) => value == InternetConnectionStatus.connected)) {
                  setState(() => clicked = false);
                  Navigator.pushReplacementNamed(context, "/");
                }else{
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("No Internet")));
                  setState(() => clicked = false);
                }
              },
              label: const Text("Check Connection")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/NoInternet.gif"),
          const Text(
            "No Internet",
            style: TextStyle(fontFamily: 'MuliBold', fontSize: 50),
          ),
        ],
      ),
    );
  }
}
