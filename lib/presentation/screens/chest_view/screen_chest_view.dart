import 'package:flutter/material.dart';
import 'package:iconsax_linear/iconsax_linear.dart';

import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';

class ScreenChestView extends StatelessWidget {
  const ScreenChestView({super.key, required this.rootPath});

  final String rootPath;

  @override
  Widget build(BuildContext context) {
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
                  itemCount: 300,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: const Icon(IconsaxLinear.gallery, size: 18),
                    title: const Text(
                      'Ender Research',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: const Icon(IconsaxLinear.arrow_right_3, size: 18),
                    onTap: () {},
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
