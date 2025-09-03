import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../../bloc/directory/directory_bloc.dart';
import '../../../bloc/directory/directory_events.dart';
import '../../../bloc/directory/directory_states.dart';
import '../../theme/app_themes.dart';
import '../../widgets/context_menu.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_fab.dart';

class ScreenChestView extends StatelessWidget {
  const ScreenChestView({super.key, required this.rootPath});

  final String rootPath;

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final ValueNotifier<bool> hasText = ValueNotifier<bool>(false);

    searchController.addListener(() {
      hasText.value = searchController.text.isNotEmpty;
    });

    return Scaffold(
      appBar: CustomAppBar(
        // rootPath: rootPath,
        // controller: searchController,
        // hasText: hasText,
        leadingIcon: IconsaxLinear.activity,
        title: 'lol',
        trailingIcon: IconsaxLinear.activity,
      ),
      body: BlocBuilder<DirectoryBloc, DirectoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return _buildDirectoryList(context, rootPath, state);
        },
      ),
      floatingActionButton: CustomFAB(rootPath: rootPath),
    );
  }

  Widget _buildDirectoryList(
    BuildContext context,
    String path,
    DirectoryState state,
  ) {
    final contents = state.folderContents[path] ?? [];

    final msg = [
      "New here? Start with a tap!",
      "This page is waiting for your genius.",
      "Looks a bit empty... for now.",
      "Don't be shy. Hit that + button.",
      "Nothing here. Yet.",
      "Every masterpiece starts with one note.",
      "Tap + and break the silence.",
      "Fresh page, fresh start!",
      "Let's make something magical.",
      "Go on. Tap it. You know you want to.",
      "Quiet, isn't it? Too quiet.",
      "Notes? Zero. Potential? Infinite.",
      "Still blank. For now.",
      "Room for thoughts. Just add one.",
      "Not much to see here. Yet.",
      "Tap + before I start singing.",
      "Feels lonely in here...",
      "Trust me, this won't write itself.",
      "You bring the idea, I'll hold the pen.",
      "One small tap for you, one giant leap for your notes.",
    ];

    if (path == rootPath && contents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            msg[Random().nextInt(msg.length)],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context)
                  .extension<EndernoteColors>()
                  ?.clrText
                  .withAlpha(200),
            ),
          ),
        ),
      );
    }

    contents.sort(
      (a, b) =>
          // Checks either both are files or both are folders
          ((a.endsWith('.md') && b.endsWith('.md')) ||
                  (!a.endsWith('.md') && !b.endsWith('.md')))
              // If true, sort that 2 elements.
              ? (a.compareTo(b))
              // else, (one folder and one file) move the folder to top.
              : (b.endsWith('.md') ? -1 : 1),
    );

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
              onSecondaryTap: () =>
                  showContextMenu(context, entityPath, isFolder, ''),
              onLongPress: () =>
                  showContextMenu(context, entityPath, isFolder, ''),
              child: ListTile(
                leading: Icon(
                  isFolder
                      ? (state.openFolders.contains(entityPath)
                          ? IconsaxLinear.arrow_down
                          : IconsaxLinear.arrow_right_3)
                      : IconsaxLinear.task_square,
                  size: 20,
                ),
                title: Transform.translate(
                  offset: Offset(-8, 0),
                  child: Text(entityPath.split('/').last),
                ),
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
}
