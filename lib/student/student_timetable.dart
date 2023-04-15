import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../redux/reducer.dart';

class StudentTimeTable extends HookWidget {
  const StudentTimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> timetable = {};
    List weekdays = DateFormat('EEEE').dateSymbols.STANDALONEWEEKDAYS;
    final selectedDay = useState(DateFormat('EEEE').format(DateTime.now()));
    var data = StoreProvider.of<AppState>(context).state;

    Future<Map<String, dynamic>> getTimetable() async {
      DocumentReference timetables = FirebaseFirestore.instance
          .doc('/College/${data.branch}/TY/Timetable');
      DocumentSnapshot timetableSnapshot = await timetables.get();
      Map temp = timetableSnapshot.data() as Map<String, dynamic>;
      List l = temp['6'][selectedDay.value].keys.toList()..sort();
      for (var element in l) {
        timetable[element] = temp['6'][selectedDay.value][element];
      }
      await Future.delayed(const Duration(milliseconds: 350));
      return timetable;
    }

    return FutureBuilder<Map<String, dynamic>>(
        future: getTimetable(),
        builder: (context, AsyncSnapshot timetable) {
          if (timetable.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        size: 50, color: Colors.red)));
          } else {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  "Time Table",
                  style: TextStyle(fontFamily: 'Narrow', fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.indigo[300],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<String>(
                        elevation: 0,
                        iconEnabledColor: Colors.red,
                        alignment: AlignmentDirectional.center,
                        value: selectedDay.value,
                        items: weekdays
                            .map<DropdownMenuItem<String>>(
                                (value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ))
                            .toList(),
                        onChanged: (newvalue) {
                          selectedDay.value = newvalue!;
                          // setState((){});
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: timetable.data == null
                        ? Center(
                            child: Container(
                                height: MediaQuery.of(context).size.height,
                                color: Colors.amber[50],
                                child:
                                    Image.asset("assets/images/holiday.gif")))
                        : ListView.builder(
                            itemCount: timetable.data.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              String key = timetable.data.keys.elementAt(index);
                              return Padding(
                                padding: const EdgeInsetsDirectional.all(20),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      const Expanded(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.access_time),
                                      )),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 80,
                                          child: Text(
                                              timetable.data[key].toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            DateFormat.Hm()
                                                .format(DateFormat('HH-mm')
                                                    .parse(key))
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
