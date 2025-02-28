import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'directory_events.dart';
import 'directory_states.dart';

class DirectoryBloc extends Bloc<DirectoryEvent, DirectoryState> {
  DirectoryBloc() : super(const DirectoryState()) {
    on<FetchDirectory>(_onFetchDirectory);
    on<ToggleFolder>(_onToggleFolder);
    on<SearchDirectory>(_onSearchDirectory);
  }

  Future<void> _onFetchDirectory(
    FetchDirectory event,
    Emitter<DirectoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final folder = Directory(event.path);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      final entities = folder.listSync();
      final List<String> contents = entities.map((e) => e.path).toList();

      emit(state.copyWith(
        folderContents: {
          ...state.folderContents,
          event.path: contents,
        },
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onToggleFolder(
    ToggleFolder event,
    Emitter<DirectoryState> emit,
  ) {
    final isOpen = state.openFolders.contains(event.path);
    final updatedOpenFolders = Set<String>.from(state.openFolders);

    if (isOpen) {
      updatedOpenFolders.remove(event.path);
    } else {
      updatedOpenFolders.add(event.path);
    }

    emit(state.copyWith(openFolders: updatedOpenFolders));
  }

  Future<void> _onSearchDirectory(
    SearchDirectory event,
    Emitter<DirectoryState> emit,
  ) async {
    emit(state.copyWith(isSearching: true, searchErrorMessage: null));

    try {
      final results = await _searchDirectory(event.rootPath, event.query);
      emit(state.copyWith(
        isSearching: false,
        searchResults: results,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSearching: false,
        searchErrorMessage: e.toString(),
      ));
    }
  }

  Future<List<String>> _searchDirectory(String rootPath, String query) async {
    if (query.isEmpty) return [];

    final results = <String>[];

    try {
      await for (final entity in Directory(rootPath).list(recursive: true)) {
        final path = entity.path;

        // Skip hidden files/directories
        if (path.split('/').last.startsWith('.')) continue;

        // Check if file name contains query
        if (path.split('/').last.toLowerCase().contains(query.toLowerCase())) {
          results.add(path);
          continue;
        }

        // If it's a file, also check its content
        if (entity is File && path.endsWith('.md')) {
          try {
            final content = await File(path).readAsString();
            if (content.toLowerCase().contains(query.toLowerCase())) {
              results.add(path);
            }
          } catch (_) {}
        }
      }
      return results;
    } catch (e) {
      throw Exception('Failed to search directory: $e');
    }
  }
}
