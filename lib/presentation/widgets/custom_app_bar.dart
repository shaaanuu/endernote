import 'package:flutter/material.dart';

import '../theme/app_themes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.leadingIcon,
    this.onLeading,
    required this.title,
    required this.trailingIcon,
    this.onTrailing,
  });

  final IconData leadingIcon;
  final void Function()? onLeading;
  final String title;
  final IconData trailingIcon;
  final void Function()? onTrailing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: onLeading,
                  icon: Icon(leadingIcon, size: 24),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context)
                          .extension<EndernoteColors>()
                          ?.clrText,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: onTrailing,
                  icon: Icon(trailingIcon, size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
