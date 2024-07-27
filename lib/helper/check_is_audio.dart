const List<String> audioFileExtensions = [
  '.mp3',
  '.wav',
  '.aac',
  '.flac',
  '.m4a',
  '.ogg',
  '.wma',
  '.aiff',
  '.midi',
  '.mid',
  '.opus',
  '.ra',
  '.ram',
  '.amr',
  '.mka',
  '.dss',
  '.spx',
  '.aifc',
  '.caf',
  '.mtx',
];

bool isAudioFile(String fileName) {
  final extension = fileName.split('.').last.toLowerCase();
  return audioFileExtensions.contains('.$extension');
}
