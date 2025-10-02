import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../../data/models/chest_record.dart';
import '../../theme/app_themes.dart';

class ScreenWelcome extends StatelessWidget {
  const ScreenWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 73),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(
                    height: 0.6,
                    fontFamily: 'SourceSans3Light',
                    fontSize: 38,
                    letterSpacing: 0.57,
                  ),
                ),
                Text(
                  'Endernote',
                  style: TextStyle(
                    fontSize: 38,
                    fontFamily: 'SourceSans3Bold',
                    letterSpacing: 0.57,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Chests keep your notes\norganized and safe.',
                  style: TextStyle(
                    height: 1.1,
                    color: Theme.of(context)
                        .extension<EndernoteColors>()
                        ?.clrTextSecondary,
                    fontFamily: 'SourceSans3Light',
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 56),
                Center(
                  child: TextButton.icon(
                    icon: Icon(
                      IconsaxLinear.add,
                      size: 24,
                    ),
                    label: Text(
                      'Create new chest',
                      style: TextStyle(fontSize: 14),
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/chest-room'),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        IconsaxLinear.folder_2,
                        size: 16,
                      ),
                    ),
                    label: Text(
                      'Open existing folder as chest',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    onPressed: () async {
                      try {
                        final pickedDirectoryPath =
                            await FilePicker.platform.getDirectoryPath();

                        if (pickedDirectoryPath != null && context.mounted) {
                          Navigator.pushNamed(
                            context,
                            '/chest-view',
                            arguments: {
                              'currentPath': pickedDirectoryPath,
                              'rootPath': pickedDirectoryPath,
                            },
                          );

                          final box = Hive.box<ChestRecord>('recentChests');
                          if (!box.values.any(
                            (element) => element.path == pickedDirectoryPath,
                          )) {
                            // If it's not already exists, add it
                            box.add(
                              ChestRecord(
                                path: pickedDirectoryPath,
                                ts: DateTime.now().millisecondsSinceEpoch,
                              ),
                            );
                          } else {
                            // if it's already exists, update it
                            final a = box.values.firstWhere(
                              (element) => element.path == pickedDirectoryPath,
                            );

                            box.putAt(
                              a.key,
                              ChestRecord(
                                path: pickedDirectoryPath,
                                ts: DateTime.now().millisecondsSinceEpoch,
                              ),
                            );
                          }
                        } else {
                          // TODO: add a error msg
                          print("Error, pick something you idiot...");
                        }
                      } catch (e) {
                        // TODO: show a error msg
                        print(e.toString());
                      }
                    },
                  ),
                ),
                SizedBox(height: 64),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent chests:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    InkResponse(
                      radius: 20,
                      child: Icon(IconsaxLinear.more),
                      onTap: () => Navigator.pushNamed(context, '/chest-room'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Material(
                  color: Theme.of(context)
                      .extension<EndernoteColors>()
                      ?.clrSecondary,
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAlias,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'Ender Research',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          '../Documents/EnderResearch',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context)
                                .extension<EndernoteColors>()
                                ?.clrTextSecondary
                                .withAlpha(128),
                          ),
                        ),
                        trailing: Text(
                          '2h ago',
                          style: TextStyle(
                            fontFamily: 'SourceSans3Light',
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context)
                                .extension<EndernoteColors>()
                                ?.clrTextSecondary
                                .withAlpha(179),
                          ),
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(IconsaxLinear.add),
        onPressed: () {},
      ),
    );
  }
}
