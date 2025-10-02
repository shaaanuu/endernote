import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'file_events.dart';
import 'file_states.dart';

class FileBloc extends Bloc<FileEvents, FileStates> {
  FileBloc() : super(FileInitial()) {
    on<LoadFiles>(
      (event, emit) async {
        emit(FileLoading());
        try {
          final List<FileSystemEntity> files =
              // check if path exists
              Directory(event.path).existsSync()
                  ?
                  // if yes, list its contents
                  Directory(event.path).listSync()
                  :
                  // else, return empty list
                  [];

          // sorting, folders -> md -> others
          files.sort((a, b) {
            if (a is Directory && b is! Directory) return -1;
            if (a is! Directory && b is Directory) return 1;

            final aMd = a.path.toLowerCase().endsWith('.md');
            final bMd = b.path.toLowerCase().endsWith('.md');
            if (aMd && !bMd) return -1;
            if (!aMd && bMd) return 1;

            return a.path.toLowerCase().compareTo(b.path.toLowerCase());
          });

          emit(FileLoaded(files));
        } catch (e) {
          emit(FileError(e.toString()));
        }
      },
    );
  }
}
