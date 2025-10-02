import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_linear/iconsax_linear.dart';
import 'package:path/path.dart';

import '../../../bloc/file/file_bloc.dart';
import '../../../bloc/file/file_events.dart';
import '../../../bloc/file/file_states.dart';
import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_fab.dart';

class ScreenChestView extends StatelessWidget {
  ScreenChestView({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  static const _fileConfig = {
    // images
    'png': {'icon': IconsaxLinear.gallery, 'route': '/image-view'},
    'jpg': {'icon': IconsaxLinear.gallery, 'route': '/image-view'},
    'jpeg': {'icon': IconsaxLinear.gallery, 'route': '/image-view'},
    'gif': {'icon': IconsaxLinear.gallery, 'route': '/image-view'},
    'bmp': {'icon': IconsaxLinear.gallery, 'route': '/image-view'},
    'webp': {'icon': IconsaxLinear.gallery, 'route': '/image-view'},

    // videos
    'mp4': {'icon': IconsaxLinear.video_play, 'route': '/video-view'},
    'mkv': {'icon': IconsaxLinear.video_play, 'route': '/video-view'},
    'mov': {'icon': IconsaxLinear.video_play, 'route': '/video-view'},
    'avi': {'icon': IconsaxLinear.video_play, 'route': '/video-view'},
    'webm': {'icon': IconsaxLinear.video_play, 'route': '/video-view'},

    // audios
    'mp3': {'icon': IconsaxLinear.audio_square, 'route': '/audio-view'},
    'wav': {'icon': IconsaxLinear.audio_square, 'route': '/audio-view'},
    'flac': {'icon': IconsaxLinear.audio_square, 'route': '/audio-view'},
    'aac': {'icon': IconsaxLinear.audio_square, 'route': '/audio-view'},
    'ogg': {'icon': IconsaxLinear.audio_square, 'route': '/audio-view'},

    // docs
    'pdf': {'icon': IconsaxLinear.image, 'route': '/pdf-view'},
    'txt': {'icon': IconsaxLinear.document_text_1, 'route': '/canvas'},
    'md': {'icon': IconsaxLinear.document_text_1, 'route': '/canvas'},
    'doc': {'icon': IconsaxLinear.document_text_1, 'route': '/doc-view'},
    'docx': {'icon': IconsaxLinear.document_text_1, 'route': '/doc-view'},
    'rtf': {'icon': IconsaxLinear.document_text_1, 'route': '/doc-view'},
  };

  IconData _getIcon(FileSystemEntity entity) {
    if (entity is Directory) return IconsaxLinear.folder;
    return (_fileConfig[entity.path.split('.').last.toLowerCase()]?['icon']
            as IconData?) ??
        IconsaxLinear.document;
  }

  String? _getRoute(FileSystemEntity entity) {
    if (entity is Directory) return '/chest-view';
    return _fileConfig[entity.path.split('.').last.toLowerCase()]?['route']
        as String?;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final args = ModalRoute.of(context)?.settings.arguments as Map;

    String currentPath = args['currentPath'];
    String rootPath = args['rootPath'];

    return BlocProvider(
      create: (context) => FileBloc()..add(LoadFiles(currentPath)),
      child: Scaffold(
        key: _key,
        appBar: CustomAppBar(
          leadingIcon: IconsaxLinear.menu,
          title: 'Ender Research',
          trailingIcon: IconsaxLinear.search_normal_1,
          onLeading: () => _key.currentState!.openDrawer(),
        ),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<FileBloc, FileStates>(
              builder: (ctx, state) {
                if (state is FileLoading) {
                  return SizedBox(
                    height: height - 70,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state is FileLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBreadcrumbs(
                        context,
                        startFrom: basename(rootPath),
                        currentPath: currentPath,
                        rootPath: rootPath,
                      ),
                      const SizedBox(height: 8),
                      if (state.files.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: (height / 2) - 75),
                          child: Center(
                            child: Text(
                              'This folder is empty…',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .extension<EndernoteColors>()
                                    ?.clrText
                                    .withAlpha(157),
                              ),
                            ),
                          ),
                        )
                      else
                        Material(
                          color: Theme.of(context)
                              .extension<EndernoteColors>()
                              ?.clrSecondary
                              .withAlpha(179),
                          borderRadius: BorderRadius.circular(10),
                          clipBehavior: Clip.antiAlias,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            shrinkWrap: true,
                            itemCount: state.files.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) => ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              leading: Icon(
                                _getIcon(state.files[index]),
                                size: 18,
                              ),
                              title: Text(
                                state.files[index].path.split('/').last,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16),
                              ),
                              trailing: (state.files[index] is Directory)
                                  ? const Icon(IconsaxLinear.arrow_right_3,
                                      size: 18)
                                  : null,
                              onTap: () {
                                // Folder -> go into chestView
                                if (state.files[index] is Directory) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/chest-view',
                                    arguments: {
                                      'currentPath': state.files[index].path,
                                      'rootPath': rootPath,
                                    },
                                  );
                                }
                                // File -> pick route by it's extension
                                else if (state.files[index] is File) {
                                  final route = _getRoute(state.files[index]);
                                  if (route != null) {
                                    Navigator.pushNamed(
                                      context,
                                      route,
                                      arguments: state.files[index].path,
                                    );
                                  } else {
                                    print(
                                        'Unsupported file: ${state.files[index].path}');
                                    // TODO: implement an error msg or something.
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 100),
                    ],
                  );
                }

                if (state is FileError) {
                  return SizedBox(
                    height: height - 70,
                    child: Center(
                      child: Text("Error"),
                    ),
                  );
                }

                return SizedBox(
                  height: height - 70,
                  child: Center(
                    child: Text(
                      'Hmmm... Something went wrong and I don\'t know what it is..',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: CustomFAB(rootPath: currentPath),
      ),
    );
  }

  Widget _buildBreadcrumbs(
    BuildContext context, {
    required String startFrom,
    required String currentPath,
    required String rootPath,
  }) {
    final parts = currentPath
        .split(Platform.pathSeparator)
        .where((e) => e.isNotEmpty)
        .toList();
    final startIndex = parts.indexOf(startFrom);
    final visibleParts = parts.sublist(startIndex);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          visibleParts.length,
          (i) {
            final path = Platform.isWindows
                ? parts.sublist(0, startIndex + i + 1).join('\\')
                : '/${parts.sublist(0, startIndex + i + 1).join('/')}';
            return Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    '/chest-view',
                    arguments: {
                      'currentPath': path,
                      'rootPath': rootPath,
                    },
                  ),
                  child: Text(
                    visibleParts[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .extension<EndernoteColors>()
                          ?.clrText
                          .withAlpha(179),
                    ),
                  ),
                ),
                if (i != visibleParts.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      IconsaxLinear.arrow_right_3,
                      size: 12,
                      color: Theme.of(context)
                          .extension<EndernoteColors>()
                          ?.clrTextSecondary
                          .withAlpha(179),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
