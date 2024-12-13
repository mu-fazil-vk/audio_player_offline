import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:music_player/core/constants/app_constants.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';

class TranslatorsScreen extends StatelessWidget {
  const TranslatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          LocaleKeys.settings.tr(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView.builder(
          itemCount: AppInfo().translators.length,
          itemBuilder: (context, index) {
            return ListTile(
              title:
                  Text(AppInfo().translators[index].name ?? 'N/A', style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(AppInfo().translators[index].languages ?? 'N/A'),
              leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  color: Theme.of(context).buttonTheme.colorScheme!.primary),
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}
