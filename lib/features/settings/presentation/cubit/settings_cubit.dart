import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/local_storage/local_storage_service.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final LocalStorageService _storage;

  SettingsCubit(this._storage)
      : super(
          const SettingsState(
            themeMode: ThemeMode.system,
            locale: Locale('en'),
          ),
        );

  Future<void> loadSettings() async {
    final savedTheme = await _storage.getThemeMode();
    final savedLocale = await _storage.getLocale();
    emit(
      SettingsState(
        themeMode: _themeFromString(savedTheme),
        locale: Locale(savedLocale ?? 'en'),
      ),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _storage.saveThemeMode(mode.name);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLocale(Locale locale) async {
    await _storage.saveLocale(locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  void toggleLocale() {
    final next =
        state.locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    setLocale(next);
  }

  ThemeMode _themeFromString(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
