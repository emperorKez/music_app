import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/app/repository/app_repo.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppRepository appRepo;
  AppBloc({required this.appRepo}) : super(AppSettingsInitial()) {
    on<GetAppSettings>(onGetAppSettings);
    on<ChangeTheme>(onChangeTheme);
  }

  Future<void> onGetAppSettings(
      GetAppSettings event, Emitter<AppState> emit) async {
    emit(AppSettingsLoading());
    try {
      var packageInfoData = await appRepo.getAppVersionInfo();
      bool darkMode = await appRepo.getTheme();
      emit(AppSettingsLoaded(packageInfo: packageInfoData, darkMode: darkMode));
    } catch (e) {
      emit(AppSettingsError(error: e.toString()));
    }
  }

  Future<void> onChangeTheme(ChangeTheme event, Emitter<AppState> emit) async {
    final packageInfoData = state.packageInfo;
    emit(AppSettingsLoading());
    try {
      await appRepo.setTheme(event.isDark);
      emit(AppSettingsLoaded(
          packageInfo: packageInfoData, darkMode: event.isDark));
    } catch (e) {
      emit(AppSettingsError(error: e.toString()));
    }
  }
}
