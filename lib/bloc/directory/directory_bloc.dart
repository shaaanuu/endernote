import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'directory_events.dart';
import 'directory_states.dart';

class DirectoryBloc extends Bloc<DirectoryEvent, DirectoryState> {
  DirectoryBloc() : super(const DirectoryState()) {
    on<FetchDirectory>(_onFetchDirectory);
    on<ToggleFolder>(_onToggleFolder);
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
}
