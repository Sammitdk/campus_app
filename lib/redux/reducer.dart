import 'package:campus_subsystem/redux/actions/fetchUserData.dart';
import 'package:redux/redux.dart';

class AppState {
  final dynamic email;
  final dynamic roll_No;
  final dynamic prn;
  final dynamic address;
  final dynamic branch;
  final dynamic mobile;
  final dynamic name;
  final dynamic sem;
  final dynamic year;
  final dynamic dob;
  final dynamic isStudent;
  final dynamic imgUrl;
  AppState(
      {this.imgUrl,
      this.isStudent,
      this.address,
      this.branch,
      this.mobile,
      this.name,
      this.sem,
      this.year,
      this.dob,
      this.email,
      this.roll_No,
      this.prn});

  AppState copyWith(
      {email,
      roll_No,
      prn,
      address,
      branch,
      mobile,
      name,
      sem,
      year,
      dob,
      isStudent,
      imgUrl}) {
    return AppState(
        address: address ?? this.address,
        branch: branch ?? this.branch,
        name: name ?? this.name,
        email: email ?? this.email,
        roll_No: roll_No ?? this.roll_No,
        prn: prn ?? this.prn,
        sem: sem ?? this.sem,
        dob: dob ?? this.dob,
        year: year ?? this.year,
        isStudent: isStudent ?? this.isStudent,
        imgUrl: imgUrl ?? this.imgUrl,
        mobile: mobile ?? this.mobile);
  }

  const AppState.initialState(
      this.email,
      this.roll_No,
      this.prn,
      this.address,
      this.branch,
      this.mobile,
      this.name,
      this.sem,
      this.year,
      this.dob,
      this.isStudent,
      this.imgUrl);
}

AppState FetchUserData(AppState state, dynamic action) {
  if (action is FetchData) {
    return state.copyWith(
        email: action.email,
        prn: action.prn,
        roll_No: action.roll_No,
        name: action.name,
        mobile: action.mobile,
        year: action.year,
        dob: action.dob,
        branch: action.branch,
        isStudent: action.isStudent,
        address: action.address,
        sem: action.sem,
        imgUrl: action.imgUrl);
  }
  return state;
}

final reducers = combineReducers<AppState>([FetchUserData]);
