import 'dart:io';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/directory/directory_bloc.dart';
import '../../../bloc/directory/directory_events.dart';
import '../../../bloc/directory/directory_states.dart';
import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';

class ScreenSearch extends StatelessWidget {
  const ScreenSearch({
    super.key,
    required this.searchQuery,
    required this.rootPath,
  });

  final String searchQuery;
  final String rootPath;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DirectoryBloc>().add(SearchDirectory(rootPath, searchQuery));
    });

    return Scaffold(
      appBar: CustomAppBar(
        rootPath: rootPath,
        searchQuery: searchQuery,
        showBackButton: true,
      ),
      body: BlocBuilder<DirectoryBloc, DirectoryState>(
        builder: (context, state) {
          if (state.isSearching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.searchErrorMessage != null) {
            return Center(
              child: Text(
                'Error: ${state.searchErrorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final searchResults = state.searchResults ?? [];

          if (searchResults.isEmpty) {
            return Center(
              child: Text(
                'No results found for "$searchQuery"',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .extension<EndernoteColors>()
                      ?.clrText
                      .withAlpha(100),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: searchResults.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final entityPath = searchResults[index];
              final isFolder = Directory(entityPath).existsSync();

              return Column(
                children: [
                  GestureDetector(
                    onLongPress: () {
                      _showContextMenu(context, entityPath, isFolder);
                    },
                    child: ListTile(
                      leading: Icon(
                        isFolder
                            ? (state.openFolders.contains(entityPath)
                                ? IconsaxOutline.folder_open
                                : IconsaxOutline.folder)
                            : IconsaxOutline.task_square,
                      ),
                      title: Text(entityPath.split('/').last),
                      subtitle: Text(
                        entityPath.replaceFirst(rootPath, ''),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .extension<EndernoteColors>()
                              ?.clrText
                              .withAlpha(150),
                        ),
                      ),
                      onTap: () {
                        if (isFolder) {
                          context
                              .read<DirectoryBloc>()
                              .add(ToggleFolder(entityPath));
                          if (!state.folderContents.containsKey(entityPath)) {
                            context
                                .read<DirectoryBloc>()
                                .add(FetchDirectory(entityPath));
                          }
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/canvas',
                            arguments: entityPath,
                          );
                        }
                      },
                    ),
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
        },
      ),
    );
  }

  Widget _buildDirectoryList(
    BuildContext context,
    String path,
    DirectoryState state,
  ) {
    final contents = state.folderContents[path] ?? [];

    if (path == rootPath && contents.isEmpty) {
      return Center(
        child: Text(
          "This folder is feeling lonely.",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context)
                .extension<EndernoteColors>()
                ?.clrText
                .withAlpha(100),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: contents.length,
      itemBuilder: (context, index) {
        final entityPath = contents[index];
        final isFolder = Directory(entityPath).existsSync();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onLongPress: () {
                _showContextMenu(context, entityPath, isFolder);
              },
              child: ListTile(
                leading: Icon(
                  isFolder
                      ? (state.openFolders.contains(entityPath)
                          ? IconsaxOutline.folder_open
                          : IconsaxOutline.folder)
                      : IconsaxOutline.task_square,
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
                  } else {
                    Navigator.pushNamed(
                      context,
                      '/canvas',
                      arguments: entityPath,
                    );
                  }
                },
              ),
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

  void _showContextMenu(
    BuildContext context,
    String entityPath,
    bool isFolder,
  ) {
    final menuItems = <PopupMenuEntry<String>>[
      const PopupMenuItem(
        value: 'rename',
        child: ListTile(
          leading: Icon(IconsaxOutline.edit_2),
          title: Text('Rename'),
        ),
      ),
      const PopupMenuItem(
        value: 'delete',
        child: ListTile(
          leading: Icon(IconsaxOutline.folder_cross),
          title: Text('Delete'),
        ),
      ),
    ];

    if (isFolder) {
      menuItems.addAll(
        [
          const PopupMenuItem(
            value: 'new_folder',
            child: ListTile(
              leading: Icon(IconsaxOutline.folder_open),
              title: Text('New Folder'),
            ),
          ),
          const PopupMenuItem(
            value: 'new_file',
            child: ListTile(
              leading: Icon(IconsaxOutline.add_square),
              title: Text('New File'),
            ),
          ),
        ],
      );
    }

    showMenu(
      color: Theme.of(context).extension<EndernoteColors>()?.clrBase,
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: menuItems,
    ).then((value) {
      if (value == 'rename') {
        _renameEntity(context, entityPath);
      } else if (value == 'delete') {
        _deleteEntity(context, entityPath, isFolder);
      } else if (value == 'new_folder') {
        _createNewFolder(context, entityPath);
      } else if (value == 'new_file') {
        _createNewFile(context, entityPath);
      }
    });
  }

  void _createNewFolder(BuildContext context, String entityPath) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            Theme.of(context).extension<EndernoteColors>()?.clrBase,
        title: Text(
          'New Folder',
          style: TextStyle(
            color: Theme.of(context).extension<EndernoteColors>()?.clrText,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Folder name',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final newFolderPath = '$entityPath/${controller.text.trim()}';
                Directory(newFolderPath).createSync();
                context.read<DirectoryBloc>().add(FetchDirectory(entityPath));
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createNewFile(BuildContext context, String entityPath) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            Theme.of(context).extension<EndernoteColors>()?.clrBase,
        title: Text(
          'New File',
          style: TextStyle(
            color: Theme.of(context).extension<EndernoteColors>()?.clrText,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'File name',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                File('$entityPath/${controller.text.trim()}.md').createSync();
                context.read<DirectoryBloc>().add(FetchDirectory(entityPath));
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _renameEntity(BuildContext context, String entityPath) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            Theme.of(context).extension<EndernoteColors>()?.clrBase,
        title: Text(
          'Rename',
          style: TextStyle(
            color: Theme.of(context).extension<EndernoteColors>()?.clrText,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'New name for ${entityPath.split('/').last}',
            hintStyle: const TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                final newPath =
                    '${Directory(entityPath).parent.path}/$newName.md';
                File(entityPath).renameSync(newPath);
                context
                    .read<DirectoryBloc>()
                    .add(FetchDirectory(Directory(entityPath).parent.path));
              }
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _deleteEntity(BuildContext context, String entityPath, bool isFolder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor:
            Theme.of(context).extension<EndernoteColors>()?.clrBase,
        title: Text(
          'Delete',
          style: TextStyle(
            color: Theme.of(context).extension<EndernoteColors>()?.clrText,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${entityPath.split('/').last}"?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (isFolder) {
                Directory(entityPath).deleteSync(recursive: true);
              } else {
                File(entityPath).deleteSync();
              }
              context
                  .read<DirectoryBloc>()
                  .add(FetchDirectory(Directory(entityPath).parent.path));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
