import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:music_player/core/constants/app_constants.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  Widget build(BuildContext context) {
    final supportedLanguages = AppInfo().supportedLanguages;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          LocaleKeys.language.tr(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListView.builder(
          itemCount: supportedLanguages.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(supportedLanguages[index].name,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: supportedLanguages[index].englishName == null
                  ? null
                  : Text(supportedLanguages[index].englishName!),
              leading: supportedLanguages[index].countryCode == null
                  ? HugeIcon(
                      icon: HugeIcons.strokeRoundedLanguageSkill,
                      color: Theme.of(context).buttonTheme.colorScheme!.primary)
                  : SizedBox(
                      width: 30,
                      height: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Flag.fromString(
                          supportedLanguages[index].countryCode!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
              trailing: context.locale == Locale(supportedLanguages[index].code)
                  ? HugeIcon(
                      icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                      color: Theme.of(context).buttonTheme.colorScheme!.primary)
                  : null,
              onTap: () {
                context.setLocale(Locale(supportedLanguages[index].code));
                context
                    .read<AppSettingsProvider>()
                    .setLanguage(supportedLanguages[index].code);
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}
