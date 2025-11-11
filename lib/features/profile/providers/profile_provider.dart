import 'package:flutter/foundation.dart';
import '../../../services/storage_service.dart';

class ProfileProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  String _themeMode = 'system';
  String _currency = 'PEN';
  String _language = 'es';
  
  String get themeMode => _themeMode;
  String get currency => _currency;
  String get language => _language;
  
  ProfileProvider() {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    _themeMode = await _storageService.getThemeMode() ?? 'system';
    _currency = await _storageService.getCurrency() ?? 'PEN';
    _language = await _storageService.getLanguage() ?? 'es';
    notifyListeners();
  }
  
  Future<void> setThemeMode(String mode) async {
    _themeMode = mode;
    await _storageService.saveThemeMode(mode);
    notifyListeners();
  }
  
  Future<void> setCurrency(String currency) async {
    _currency = currency;
    await _storageService.saveCurrency(currency);
    notifyListeners();
  }
  
  Future<void> setLanguage(String language) async {
    _language = language;
    await _storageService.saveLanguage(language);
    notifyListeners();
  }
}