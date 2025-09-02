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
        toolbarHeight: 80,
        title: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).extension<EndernoteColors>()?.clrSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onLeading ?? () {},
                icon: Icon(leadingIcon),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: onTrailing ?? () {},
                icon: Icon(trailingIcon),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
