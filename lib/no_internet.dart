import 'package:flutter/cupertino.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/image/NoInternet"),
        const Text("No Internet",style: TextStyle(fontFamily: 'Custom',fontSize: 20),),
      ],
    );
  }
}
