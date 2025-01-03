import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:music_player/core/constants/app_constants.dart';
import 'package:music_player/core/generated/l10n/locale_keys.g.dart';
import 'package:music_player/core/utils/size_extension.dart';
import 'package:music_player/widgets/common/snackbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int count = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.about.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
        ),
        10.ph,
        ListTile(
          title: Text(LocaleKeys.developer.tr(),
              style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(AppInfo().developerName),
          leading: Icon(Icons.code,
              color: Theme.of(context).buttonTheme.colorScheme!.primary),
          onTap: () {
            _launchUrl(AppInfo().developerUrl);
          },
        ),
        10.ph,
        ListTile(
          title: Text(LocaleKeys.translators.tr(),
              style: Theme.of(context).textTheme.titleMedium),
          leading: Icon(Icons.translate,
              color: Theme.of(context).buttonTheme.colorScheme!.primary),
          onTap: () {
            context.goNamed('translators');
          },
        ),
        10.ph,
        ListTile(
          title: Text(LocaleKeys.version.tr(),
              style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text(AppInfo().appVersion),
          leading: Icon(Icons.info_outline,
              color: Theme.of(context).buttonTheme.colorScheme!.primary),
          onTap: () {
            count++;
            if (count == 3) {
              showCustomSnackBar(context, LocaleKeys.youAreCuriousOne.tr());
              count = 0;
            }
          },
        ),
        10.ph,
        ListTile(
          title: Text(LocaleKeys.license.tr(),
              style: Theme.of(context).textTheme.titleMedium),
          subtitle: const Text('MIT License'),
          leading: HugeIcon(
              icon: HugeIcons.strokeRoundedLicense,
              color: Theme.of(context).buttonTheme.colorScheme!.primary),
          onTap: () {},
        ),
        20.ph,
      ],
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
