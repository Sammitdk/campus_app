import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import '../faculty/faculty_dashboard.dart';
import '../login_page.dart';
import '../redux/reducer.dart';
import '../student/student_dashboard.dart';

class Wrapper extends HookWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          if (user == null) {
            return const Login();
          } else {
            if(state.isStudent) {
              return const StudentDashboard();
            }else{
              return const FacultyDashboard();
            }
          }
        });
  }
}


// internetConnectionCheck() {
//   InternetConnectionChecker().onStatusChange.listen((status) {
//     switch (status) {
//       case InternetConnectionStatus.connected:
//         break;
//       case InternetConnectionStatus.disconnected:
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const NoInternet()));
//         break;
//     }
//   });
// }