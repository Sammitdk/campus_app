import 'package:campus_subsystem/redux/reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final Store<AppState> store = Store<AppState>(reducers,
    initialState: const AppState.initialState(
        null, null, null, null, null, null, null, null, null, null, null, null),
    middleware: [thunkMiddleware]);
