import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexacode/widgets/language_picker.dart';
import 'package:nexacode/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool glowEnabled = true;
  bool darkMode = true;

  final List<String> codeLanguages = ['Dart', 'Python', 'JavaScript'];
  String selectedCodeLang = 'Dart'; // Default

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!.translate;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        title: Text(
          t('settings'),
          style: const TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'FiraCode',
            fontSize: 20,
            shadows: [Shadow(color: Colors.greenAccent, blurRadius: 8)],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '>> ${t('preferences')}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.greenAccent,
                fontFamily: 'FiraCode',
                shadows: [Shadow(color: Colors.green, blurRadius: 8)],
              ),
            ),
            const SizedBox(height: 20),
            _buildToggle(
              label: t('enableGlow'),
              value: glowEnabled,
              onChanged: (val) => setState(() => glowEnabled = val),
            ),
            const SizedBox(height: 12),
            _buildToggle(
              label: t('darkMode'),
              value: darkMode,
              onChanged: (val) => setState(() => darkMode = val),
            ),
            const SizedBox(height: 32),

            // 🌐 Language Picker
            Text(
              '>> ${t('language')}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.greenAccent,
                fontFamily: 'FiraCode',
                shadows: [Shadow(color: Colors.green, blurRadius: 8)],
              ),
            ),
            const SizedBox(height: 12),
            LanguagePicker(),

            const SizedBox(height: 32),

            // 💻 Programming Language Selector
            const Text(
              '>> Programming Language',
              style: TextStyle(
                fontSize: 18,
                color: Colors.greenAccent,
                fontFamily: 'FiraCode',
                shadows: [Shadow(color: Colors.green, blurRadius: 8)],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.greenAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.black,
                  value: selectedCodeLang,
                  iconEnabledColor: Colors.greenAccent,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'FiraCode',
                    fontSize: 14,
                  ),
                  items: codeLanguages.map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (val) {
                    setState(() => selectedCodeLang = val!);
                    // TODO: Save to LocaleManager or SharedPreferences
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  t('logout'),
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'FiraCode',
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'FiraCode',
            fontSize: 14,
            shadows: [Shadow(color: Colors.green, blurRadius: 6)],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.greenAccent,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.shade800,
        ),
      ],
    );
  }
}
