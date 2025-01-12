import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final String firebaseUrl;
  final String localNotesDirectory;

  SyncBloc({
    required this.localNotesDirectory,
    required this.firebaseUrl,
  }) : super(SyncInitial()) {
    on<SyncDirectoryToFirebase>(_handleSyncDirectoryToFirebase);
    on<SyncFirebaseToDirectory>(_handleSyncFirebaseToDirectory);
  }

  Future<void> _handleSyncDirectoryToFirebase(
    SyncDirectoryToFirebase event,
    Emitter<SyncState> emit,
  ) async {
    emit(SyncLoading());

    try {
      final directory = Directory(localNotesDirectory);
      if (!directory.existsSync()) {
        emit(const SyncFailure(error: 'Directory not found'));
        return;
      }

      final files = directory.listSync(recursive: true);

      for (var file in files) {
        if (file is File) {
          await _uploadFileToFirebase(file);
        }
      }

      emit(SyncSuccess());
    } catch (e) {
      emit(SyncFailure(error: e.toString()));
    }
  }

  Future<void> _handleSyncFirebaseToDirectory(
    SyncFirebaseToDirectory event,
    Emitter<SyncState> emit,
  ) async {
    emit(SyncLoading());

    try {
      final directory = Directory(localNotesDirectory);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final response = await http.get(
        Uri.parse('$firebaseUrl/notes.json'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        for (var entry in data.entries) {
          final fileName = entry.key;
          final content = entry.value['fields']['content'];

          final sanitizedFileName = fileName.replaceAll('_', '.');

          final filePath = join(directory.path, sanitizedFileName);
          final fileDir = Directory(dirname(filePath));

          if (!fileDir.existsSync()) {
            fileDir.createSync(recursive: true);
          }

          final file = File(filePath);
          await file.writeAsString(content);
        }

        emit(SyncSuccess());
      } else {
        emit(const SyncFailure(error: 'Failed to fetch files from Firebase'));
      }
    } catch (e) {
      emit(SyncFailure(error: e.toString()));
    }
  }

  Future<void> _uploadFileToFirebase(File file) async {
    final fileName = basename(file.path);

    final sanitizedFileName = fileName.replaceAll(
      RegExp(r'[^a-zA-Z0-9-_]'),
      '_',
    );

    var url = '$firebaseUrl/notes/$sanitizedFileName.json';

    final fileContent = await file.readAsString();
    final body = jsonEncode({
      'fields': {'content': fileContent},
    });

    try {
      var response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception(
          'Failed to upload file: $fileName. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {}
  }
}
