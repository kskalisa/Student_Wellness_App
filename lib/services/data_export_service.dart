import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';

import 'database_service.dart';

class DataExportService {
  final DatabaseService _db;

  DataExportService(this._db);

  Future<String> createUserDataExport(String userId) async {
    final tempDir = await getTemporaryDirectory();
    final exportDir = Directory('${tempDir.path}/export_$userId');
    await exportDir.create(recursive: true);

    // Export journals
    final journals = await _db.getJournalEntries(userId);
    final journalsFile = File('${exportDir.path}/journals.json');
    await journalsFile.writeAsString(jsonEncode(journals));

    // Export moods
    final moods = await _db.getMoods(userId);
    final moodsFile = File('${exportDir.path}/moods.json');
    await moodsFile.writeAsString(jsonEncode(moods));

    // Zip the files
    final zipFile = File('${tempDir.path}/user_${userId}_data.zip');
    final encoder = ZipFileEncoder();
    encoder.create(zipFile.path);
    encoder.addDirectory(exportDir);
    encoder.close();

    return zipFile.path;
  }
}