import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../language_service.dart';
import '../languages.dart';

class LanguageDropdown extends StatelessWidget {
  final LanguageService languageService;

  LanguageDropdown({required this.languageService});

  @override
  Widget build(BuildContext context) {
    final languages = Languages().keys;
    final items = languages.keys.map((key) {
      final language = languages[key]?['selected_language'] ?? key;
      return DropdownMenuItem(value: key, child: Text(language));
    }).toList();

    return Expanded(
      child: DropdownButton<String>(
        value: languageService.currentLocale?.toString(),
        items: items,
        onChanged: (value) {
          if (value != null) {
            final parts = value.split('_');
            final locale = Locale(parts[0], parts[1]);
            languageService.updateLocale(locale);
          }
        },
        isExpanded: true,
        hint: Text('Select Language'),
      ),
    );
  }
}