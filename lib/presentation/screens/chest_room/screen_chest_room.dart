import 'package:flutter/material.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';

class ScreenChestRoom extends StatelessWidget {
  const ScreenChestRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leadingIcon: IconsaxLinear.arrow_left_1,
        title: 'Chest Room',
        trailingIcon: IconsaxLinear.box_search,
        onLeading: () => Navigator.pop(context),
      ),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              tileColor:
                  Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
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
}
