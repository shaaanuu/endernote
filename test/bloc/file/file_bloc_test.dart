import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:endernote/bloc/file/file_bloc.dart';
import 'package:endernote/bloc/file/file_events.dart';
import 'package:endernote/bloc/file/file_states.dart';

void main() {
  group('FileBloc', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('endernote_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    test('initial state is FileInitial', () {
      expect(FileBloc().state, isA<FileInitial>());
    });

    blocTest<FileBloc, FileStates>(
      'emits [FileLoading, FileLoaded] for valid empty directory',
      build: () => FileBloc(),
      act: (bloc) => bloc.add(LoadFiles(tempDir.path)),
      expect: () => [
        isA<FileLoading>(),
        isA<FileLoaded>(),
      ],
    );

    blocTest<FileBloc, FileStates>(
      'emits [FileLoading, FileLoaded] with empty list for non-existent path',
      build: () => FileBloc(),
      act: (bloc) => bloc.add(LoadFiles('/this/path/does/not/exist')),
      expect: () => [
        isA<FileLoading>(),
        predicate<FileStates>(
          (s) => s is FileLoaded && s.files.isEmpty,
          'FileLoaded with empty list',
        ),
      ],
    );

    blocTest<FileBloc, FileStates>(
      'loads files and sorts: folders first, then .md, then others',
      build: () => FileBloc(),
      act: (bloc) {
        // create files in reverse order
        File('${tempDir.path}/z_other.txt').createSync();
        File('${tempDir.path}/a_note.md').createSync();
        Directory('${tempDir.path}/my_folder').createSync();

        bloc.add(LoadFiles(tempDir.path));
      },
      expect: () => [
        isA<FileLoading>(),
        predicate<FileStates>((s) {
          if (s is! FileLoaded) return false;
          final files = s.files;
          return files[0] is Directory &&
              files[1].path.endsWith('.md') &&
              files[2].path.endsWith('.txt');
        }, 'folders → .md → others'),
      ],
    );

    blocTest<FileBloc, FileStates>(
      'sorts multiple .md files alphabetically',
      build: () => FileBloc(),
      act: (bloc) {
        File('${tempDir.path}/z_note.md').createSync();
        File('${tempDir.path}/a_note.md').createSync();
        File('${tempDir.path}/m_note.md').createSync();

        bloc.add(LoadFiles(tempDir.path));
      },
      expect: () => [
        isA<FileLoading>(),
        predicate<FileStates>((s) {
          if (s is! FileLoaded) return false;
          final paths = s.files.map((f) => f.path.split('/').last).toList();
          return paths[0] == 'a_note.md' &&
              paths[1] == 'm_note.md' &&
              paths[2] == 'z_note.md';
        }, 'md files sorted alphabetically'),
      ],
    );

    blocTest<FileBloc, FileStates>(
      'emits new FileLoaded on consecutive LoadFiles events',
      build: () => FileBloc(),
      act: (bloc) async {
        final dir2 = Directory.systemTemp.createTempSync('endernote_test2_');
        File('${dir2.path}/note.md').createSync();

        bloc.add(LoadFiles(tempDir.path)); // empty
        await Future.delayed(Duration.zero);
        bloc.add(LoadFiles(dir2.path)); // 1 file

        addTearDown(() => dir2.deleteSync(recursive: true));
      },
      expect: () => [
        isA<FileLoading>(),
        predicate<FileStates>(
          (s) => s is FileLoaded && s.files.isEmpty,
          'empty dir',
        ),
        isA<FileLoading>(),
        predicate<FileStates>(
          (s) => s is FileLoaded && s.files.length == 1,
          'dir with 1 file',
        ),
      ],
    );
  });
}
