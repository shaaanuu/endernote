import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';

class ScreenChestView extends StatelessWidget {
  const ScreenChestView({super.key, required this.rootPath});

  final String rootPath;

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
    final files =
        // check if path exists
        Directory(rootPath).existsSync()
            ?
            // if yes, list its contents
            Directory(rootPath).listSync()
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

    return Scaffold(
      appBar: CustomAppBar(
        leadingIcon: IconsaxLinear.menu,
        title: 'Ender Research',
        trailingIcon: IconsaxLinear.search_normal_1,
        onLeading: () => Navigator.popAndPushNamed(context, '/'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBreadcrumbs(context),
              const SizedBox(height: 8),
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
                  itemCount: files.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: Icon(
                      _getIcon(files[index]),
                      size: 18,
                    ),
                    title: Text(
                      files[index].path.split('/').last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: (files[index] is Directory)
                        ? const Icon(IconsaxLinear.arrow_right_3, size: 18)
                        : null,
                    onTap: () {
                      // Folder -> go into chestView
                      if (files[index] is Directory) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScreenChestView(
                              rootPath: files[index].path,
                            ),
                          ),
                        );
                      }
                      // File -> pick route by it's extension
                      else if (files[index] is File) {
                        final route = _getRoute(files[index]);
                        if (route != null) {
                          Navigator.pushNamed(
                            context,
                            route,
                            arguments: files[index].path,
                          );
                        } else {
                          print('Unsupported file: ${files[index].path}');
                          // TODO: implement an error msg or something.
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(IconsaxLinear.add),
        onPressed: () {},
      ),
    );
  }

  Widget _buildBreadcrumbs(
    BuildContext context, {
    // Only shows after this folder
    String startFrom = 'Endernote',
  }) {
    final parts = rootPath
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
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScreenChestView(rootPath: path),
                    ),
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
