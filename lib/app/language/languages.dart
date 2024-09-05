import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    final storage = GetStorage();
    final configJson = storage.read('configurations');
    if (configJson == null) {
      // Return default translations if configuration is not available
      return {
        'fr_FR': {
          'selected_language': 'french',
          'greeting': 'Bonjour',
          'enrollment': 'Enrôlement',
          'Theme': 'थेम',
          'openimis': 'openIMIS',
          'poverty_status': 'État de pauvreté',
        },
        'en_US': {
          'selected_language': 'English',
          'greeting': 'Hello',
          'enrollment': 'Enrollment',
          'theme': 'Theme',
          'openimis': 'openIMIS',
          'poverty_status': 'Poverty Status',
        },
      };
    }

    // Parse JSON string to a Map
    // final Map<String, dynamic> config = json.decode(configJson);

    // Extract the languages map
    final Map<String, dynamic> languages = configJson['languages'] ?? {};

    // Convert to required format for GetX
    return languages.map(
          (key, value) {
        final Map<String, String> languageMap = {};
        if (value is Map<String, dynamic>) {
          value.forEach((k, v) {
            languageMap[k] = v.toString();
          });
        }
        return MapEntry(key, languageMap);
      },
    );
  }
}
