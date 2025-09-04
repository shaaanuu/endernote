import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';

class ScreenChestView extends StatelessWidget {
  const ScreenChestView({super.key, required this.rootPath});

  final String rootPath;

  static const _iconMap = {
    'png': IconsaxLinear.gallery,
    'jpg': IconsaxLinear.gallery,
    'jpeg': IconsaxLinear.gallery,
    'gif': IconsaxLinear.gallery,
    'bmp': IconsaxLinear.gallery,
    'webp': IconsaxLinear.gallery,
    'mp4': IconsaxLinear.video_play,
    'mkv': IconsaxLinear.video_play,
    'mov': IconsaxLinear.video_play,
    'avi': IconsaxLinear.video_play,
    'webm': IconsaxLinear.video_play,
    'mp3': IconsaxLinear.audio_square,
    'wav': IconsaxLinear.audio_square,
    'flac': IconsaxLinear.audio_square,
    'aac': IconsaxLinear.audio_square,
    'ogg': IconsaxLinear.audio_square,
    'pdf': IconsaxLinear.document_text_1,
    'txt': IconsaxLinear.document_text_1,
    'md': IconsaxLinear.document_text_1,
    'doc': IconsaxLinear.document_text_1,
    'docx': IconsaxLinear.document_text_1,
    'rtf': IconsaxLinear.document_text_1,
  };

  IconData _getIcon(FileSystemEntity entity) {
    if (entity is Directory) return IconsaxLinear.folder;
    return _iconMap[entity.path.split('.').last.toLowerCase()] ??
        IconsaxLinear.document;
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
            children: [
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
                      if (files[index] is Directory) {
                        // Navigate into folder
                        print(files[index].path);
                      } else if (files[index] is File) {
                        // Open or preview the file
                        print(files[index].path);
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
}
