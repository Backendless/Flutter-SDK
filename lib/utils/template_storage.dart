import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TemplateStorage {
  static final Future<SharedPreferences> _templates =
      SharedPreferences.getInstance();

  static Future<void> saveTemplate(
      String templateName, Map templateValues) async {
    var templates = await _templates;
    String encodedValues = jsonEncode(templateValues);
    await templates.setString(templateName, encodedValues);
  }

  static Future<Object?> getTemplate(String templateName) async {
    var template = await _templates;

    if (template.containsKey(templateName)) {
      return template.get(templateName);
    }

    return null;
  }

  static Future<void> removeAllTemplates() async {
    var template = await _templates;
    var res = await template.clear();
    // ignore:avoid_print
    print('clearing result: $res');
  }

  static Future<bool> containsTemplate(String templateName) async {
    var template = await _templates;
    return template.containsKey(templateName);
  }
}
