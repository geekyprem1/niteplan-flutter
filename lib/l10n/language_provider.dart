import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_strings.dart';

export 'app_strings.dart' show AppLanguage;

class LanguageProvider extends ChangeNotifier {
  static const _prefKey = 'app_language';

  AppLanguage _language = AppLanguage.english;
  AppLanguage get language => _language;

  bool get isHinglish => _language == AppLanguage.hinglish;
  bool get isEnglish => _language == AppLanguage.english;

  String get languageLabel =>
      _language == AppLanguage.hinglish ? '🇮🇳 Hinglish' : '🇺🇸 English';

  // ── String lookup ──
  String tr(String key) => AppStrings.get(key, _language);

  // ── Load from SharedPreferences on app start ──
  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved == 'hinglish') {
      _language = AppLanguage.hinglish;
    } else {
      _language = AppLanguage.english;
    }
    notifyListeners();
  }

  // ── Set language — instant switch ──
  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners(); // Instant UI update

    // Persist locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefKey,
      lang == AppLanguage.hinglish ? 'hinglish' : 'english',
    );

    // Sync to Firestore (fire-and-forget)
    _syncToFirestore(lang);
  }

  // ── Restore from Firestore (on new device login) ──
  Future<void> syncFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final lang = doc.data()?['language'] as String?;
        if (lang == 'hinglish') {
          await setLanguage(AppLanguage.hinglish);
        } else if (lang == 'english') {
          await setLanguage(AppLanguage.english);
        }
      }
    } catch (_) {
      // Offline — use local preference
    }
  }

  void _syncToFirestore(AppLanguage lang) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'language': lang == AppLanguage.hinglish ? 'hinglish' : 'english',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Will sync on next opportunity
    }
  }
}



