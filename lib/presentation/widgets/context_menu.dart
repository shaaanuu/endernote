import 'dart:io';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/directory/directory_bloc.dart';
import '../../bloc/directory/directory_events.dart';
import '../theme/app_themes.dart';

void showContextMenu(
  BuildContext context,
  String entityPath,
  bool isFolder,
  String searchQuery,
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
    switch (value) {
      case 'rename':
        _renameEntity(context, entityPath, searchQuery, isFolder);
        break;
      case 'delete':
        _deleteEntity(context, entityPath, isFolder);
        break;
      case 'new_folder':
        _createNewFolder(context, entityPath);
        break;
      case 'new_file':
        _createNewFile(context, entityPath);
        break;
    }
  });
}

void _createNewFolder(BuildContext context, String entityPath) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).extension<EndernoteColors>()?.clrBase,
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
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            Directory(
              '$entityPath/${value.trim()}', // new folder path
            ).createSync();
            context.read<DirectoryBloc>().add(FetchDirectory(entityPath));
          }
          Navigator.pop(context);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              Directory(
                '$entityPath/${controller.text.trim()}', // new folder path
              ).createSync();
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
      backgroundColor: Theme.of(context).extension<EndernoteColors>()?.clrBase,
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
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            File(
              '$entityPath/${value.trim()}.md', // new file name
            ).createSync();
            context.read<DirectoryBloc>().add(FetchDirectory(entityPath));
          }
          Navigator.pop(context);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              File(
                '$entityPath/${controller.text.trim()}.md', // new file name
              ).createSync();
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

void _renameEntity(
  BuildContext context,
  String entityPath,
  String searchQuery,
  bool isFolder,
) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).extension<EndernoteColors>()?.clrBase,
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
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            if (isFolder) {
              Directory(entityPath).renameSync(
                '${Directory(entityPath).parent.path}/${value.trim()}', // updated folder name
              );
            } else {
              File(entityPath).renameSync(
                '${Directory(entityPath).parent.path}/${value.trim()}.md', // updated file name
              );
            }

            // refresh home screen
            context
                .read<DirectoryBloc>()
                .add(FetchDirectory(Directory(entityPath).parent.path));

            // refresh search screen
            context
                .read<DirectoryBloc>()
                .add(FetchDirectory(Directory(entityPath).parent.path));
          }
          Navigator.pop(context);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              if (isFolder) {
                Directory(entityPath).renameSync(
                  '${Directory(entityPath).parent.path}/${controller.text.trim()}', // updated folder name
                );
              } else {
                File(entityPath).renameSync(
                  '${Directory(entityPath).parent.path}/${controller.text.trim()}.md', // updated file name
                );
              }

              // refresh home screen
              context
                  .read<DirectoryBloc>()
                  .add(FetchDirectory(Directory(entityPath).parent.path));

              // refresh search screen
              context.read<DirectoryBloc>().add(SearchDirectory(
                  Directory(entityPath).parent.path, searchQuery));
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
      backgroundColor: Theme.of(context).extension<EndernoteColors>()?.clrBase,
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
