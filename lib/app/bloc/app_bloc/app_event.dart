part of 'app_bloc.dart';

@immutable
class AppEvent {}

class GetAppSettings extends AppEvent {}

class ChangeTheme extends AppEvent {
  final bool isDark;
  ChangeTheme({
    this.isDark = false,
  });
}
