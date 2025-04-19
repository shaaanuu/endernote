import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.controller,
    this.searchQuery,
    this.hasText,
    required this.rootPath,
    this.showBackButton = false,
  });

  final TextEditingController? controller;
  final String? searchQuery;
  final ValueNotifier<bool>? hasText;
  final String rootPath;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(80),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            if (showBackButton)
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(IconsaxOutline.arrow_left_2),
              ),
            Expanded(
              child: controller != null
                  ? TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Search your notes",
                        hintStyle: TextStyle(
                          color: Colors.white.withAlpha(100),
                          fontSize: 14,
                          fontFamily: 'FiraCode',
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: showBackButton
                            ? null
                            : const EdgeInsets.only(left: 15),
                      ),
                      onSubmitted: (value) {
                        if (controller!.text.trim().isNotEmpty) {
                          Navigator.pushNamed(context, '/search', arguments: {
                            'query': controller!.text.trim(),
                            'rootPath': rootPath
                          });
                        }
                        controller!.clear();
                      },
                    )
                  : Text('Results for "$searchQuery"'),
            ),
            if (controller != null && hasText != null)
              ValueListenableBuilder<bool>(
                valueListenable: hasText!,
                builder: (_, hasTextValue, __) => IconButton(
                  onPressed: () {
                    if (hasTextValue && controller!.text.trim().isNotEmpty) {
                      Navigator.pushNamed(context, '/search', arguments: {
                        'query': controller!.text.trim(),
                        'rootPath': rootPath
                      });
                    } else {
                      Navigator.pushNamed(context, '/settings');
                    }
                  },
                  tooltip: hasTextValue ? 'Search' : 'Settings',
                  icon: Icon(
                    hasTextValue
                        ? IconsaxOutline.search_normal_1
                        : IconsaxOutline.setting_2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
