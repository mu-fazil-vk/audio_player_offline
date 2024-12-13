import 'package:music_player/models/translator.dart';

const String kTestImage = 'assets/test.jpg';

class AppInfo {
  final String appName = 'Music Player';
  final String appVersion = '1.0.0';

  final String developerName = 'Fazil vk';
  final String developerUrl = 'https://github.com/mu-fazil-vk/';

  final List<Translator> translators = [
    Translator(
      name: 'Fazil vk',
      languages: 'English, Malayalam',
      profileUrl: 'https://github.com/mu-fazil-vk/',
    ),
  ];
}
