import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/directory/directory_bloc.dart';
import '../../../bloc/directory/directory_events.dart';
import '../../../bloc/directory/directory_states.dart';

class HomeNew extends StatelessWidget {
  final String rootPath;

  const HomeNew({super.key, required this.rootPath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DirectoryBloc()..add(FetchDirectory(rootPath)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("For testing purposes..."),
        ),
        body: BlocBuilder<DirectoryBloc, DirectoryState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }

            return _buildDirectoryList(context, rootPath, state);
          },
        ),
      ),
    );
  }

  Widget _buildDirectoryList(
    BuildContext context,
    String path,
    DirectoryState state,
  ) {
    final contents = state.folderContents[path] ?? [];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contents.length,
      itemBuilder: (context, index) {
        final entityPath = contents[index];
        final isFolder = Directory(entityPath).existsSync();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(
                isFolder
                    ? (state.openFolders.contains(entityPath)
                        ? Icons.folder_open
                        : Icons.folder)
                    : Icons.insert_drive_file,
              ),
              title: Text(entityPath.split('/').last),
              onTap: () {
                if (isFolder) {
                  context.read<DirectoryBloc>().add(ToggleFolder(entityPath));
                  if (!state.folderContents.containsKey(entityPath)) {
                    context
                        .read<DirectoryBloc>()
                        .add(FetchDirectory(entityPath));
                  }
                }
              },
            ),
            if (isFolder && state.openFolders.contains(entityPath))
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: _buildDirectoryList(context, entityPath, state),
              ),
          ],
        );
      },
    );
  }
}
