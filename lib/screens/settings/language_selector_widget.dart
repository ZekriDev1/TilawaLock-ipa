import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import '../../core/localization/l10n_config.dart';

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return Column(
      children: L10nConfig.supportedLanguages.map((lang) {
        final isSelected = localeProvider.locale.languageCode == lang.code;
        return RadioListTile<String>(
          title: Text(lang.nativeName),
          subtitle: Text(lang.name),
          value: lang.code,
          groupValue: localeProvider.locale.languageCode,
          onChanged: (value) {
            if (value != null) {
              localeProvider.setLocale(value);
            }
          },
          secondary: isSelected 
              ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) 
              : null,
          controlAffinity: ListTileControlAffinity.trailing,
        );
      }).toList(),
    );
  }
}
