import 'dart:io';
import 'dart:convert';

void main() {
  // 1. Look at the folder the script is currently sitting in
  final dir = Directory.current;
  
  // 2. Find all files that end in .mp3
  final files = dir.listSync().whereType<File>().where((f) => f.path.toLowerCase().endsWith('.mp3')).toList();

  if (files.isEmpty) {
    print('No MP3 files found in this folder!');
    return;
  }

  List<Map<String, dynamic>> library = [];

  // 3. Loop through every MP3 and build its data
  for (int i = 0; i < files.length; i++) {
    final file = files[i];
    final fileName = file.uri.pathSegments.last;
    
    // Remove the .mp3 from the name
    final cleanName = fileName.replaceAll(RegExp(r'\.mp3$', caseSensitive: false), '');

    String title = cleanName;
    String artist = "Unknown Artist";

    // If the file is named "Artist - Title", split it up!
    if (cleanName.contains(" - ")) {
      final parts = cleanName.split(" - ");
      artist = parts[0].trim();
      title = parts[1].trim();
    }

    library.add({
      "id": "song_${DateTime.now().millisecondsSinceEpoch}_$i",
      "title": title,
      "artist": artist,
      "album": "Single",
      "fileName": fileName,
      "albumArtUrl": "" // Leave empty for now, the app will handle it
    });
  }

  // 4. Save it all into library.json
  final jsonString = const JsonEncoder.withIndent('  ').convert(library);
  File('library.json').writeAsStringSync(jsonString);

  print('Success! Generated library.json with ${library.length} songs.');
}