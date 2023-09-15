part of 'app_bloc.dart';

@immutable
class AppState {
  // final Map<String, String>? loginData;
  final PackageInfo? packageInfo;
  final bool darkMode;
  final bool notification;
  final String? appDocRoot;
  const AppState(
      {this.packageInfo,
      this.darkMode = false,
      this.notification = true,
      this.appDocRoot});

  AppState copyWith({
    Map<String, String>? loginPrefData,
    PackageInfo? packageInfo,
    bool isFirstRun = true,
  }) {
    return AppState(
      // loginData: loginPrefData ?? this.loginData,
      packageInfo: packageInfo ?? this.packageInfo,
      // darkMode: darkMode ?? this.darkMode
    );
  }
}

class AppSettingsInitial extends AppState {}

class AppSettingsLoading extends AppState {}

class AppSettingsLoaded extends AppState {
  const AppSettingsLoaded(
      {required super.packageInfo, required super.darkMode, super.appDocRoot});
}

class AppSettingsError extends AppState {
  final String error;
  const AppSettingsError({this.error = 'Something went wrong'});
}
