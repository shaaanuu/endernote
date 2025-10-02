import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax_linear/iconsax_linear.dart';
import 'package:path/path.dart';

import '../../../data/models/chest_record.dart';
import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';

class ScreenChestRoom extends StatelessWidget {
  ScreenChestRoom({super.key});

  final box = Hive.box<ChestRecord>('recentChests');

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width / 14).floor();

    String shortPath(String text) {
      if (text.length <= width) return text;
      return '...${text.substring(text.length - width)}';
    }

    return Scaffold(
      appBar: CustomAppBar(
        leadingIcon: IconsaxLinear.arrow_left_1,
        title: 'Chest Room',
        trailingIcon: IconsaxLinear.box_search,
        onLeading: () => Navigator.pop(context),
      ),
      body: ListView.builder(
        itemCount: box.length,
        padding: const EdgeInsets.only(bottom: 80),
        itemBuilder: (context, index) {
          final values = box.values.toList();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              tileColor: Theme.of(context)
                  .extension<EndernoteColors>()
                  ?.clrSecondary
                  .withAlpha(179),
              title: Text(
                basename(values[index].path),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context)
                      .extension<EndernoteColors>()
                      ?.clrTextSecondary,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                shortPath(values[index].path),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context)
                      .extension<EndernoteColors>()
                      ?.clrTextSecondary
                      .withAlpha(128),
                ),
              ),
              trailing: Text(
                shortTimeAgo(values[index].ts),
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
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/chest-view',
                (route) => false,
                arguments: {
                  'currentPath': values[index].path,
                  'rootPath': values[index].path,
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(IconsaxLinear.add),
        onPressed: () {},
      ),
    );
  }

  String shortTimeAgo(int ts) {
    final diff = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(ts),
    );

    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';

    return '${diff.inSeconds}s ago';
  }
}
