import 'dart:io';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../bloc/directory/directory_bloc.dart';
import '../../../bloc/directory/directory_events.dart';
import '../../../bloc/directory/directory_states.dart';
import '../../theme/endernote_theme.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key, required this.rootPath});

  final String rootPath;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);
    TextEditingController folderController = TextEditingController();
    TextEditingController fileController = TextEditingController();

    return BlocProvider(
      create: (_) => DirectoryBloc()..add(FetchDirectory(rootPath)),
      child: Scaffold(
        appBar: AppBar(title: const Text("Endernote")),
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
        floatingActionButton: SpeedDial(
          openCloseDial: isDialOpen,
          children: [
            SpeedDialChild(
              child: const Icon(IconsaxOutline.folder),
              label: "Folder",
              onTap: () => showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: clrBase,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "New Folder",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: folderController,
                            decoration: const InputDecoration(
                              hintText: 'Folder name',
                              hintStyle: TextStyle(
                                color: clrText,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  folderController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text("Create"),
                                onPressed: () async {
                                  if (folderController.text != "") {
                                    await Directory(
                                      '$rootPath/${folderController.text}',
                                    ).create(recursive: true);
                                  }
                                  folderController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SpeedDialChild(
              child: const Icon(IconsaxOutline.task_square),
              label: "Note",
              onTap: () => showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: clrBase,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "New File",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: fileController,
                            decoration: const InputDecoration(
                              hintText: 'File name',
                              hintStyle: TextStyle(
                                color: clrText,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  fileController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text("Create"),
                                onPressed: () async {
                                  if (fileController.text != "") {
                                    await File(
                                      '$rootPath/${fileController.text}.md',
                                    ).create(recursive: true);
                                  }
                                  fileController.clear();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          child: const Icon(IconsaxOutline.add),
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
