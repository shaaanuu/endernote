import 'package:flutter/material.dart';

import '../theme/app_themes.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.lead,
    required this.title,
    this.subtitle,
    this.trail,
    this.onTap,
  });

  final IconData lead;
  final String title;
  final String? subtitle;
  final IconData? trail;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(lead),
          title: Text(title),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: TextStyle(
                    color: Theme.of(context)
                        .extension<EndernoteColors>()
                        ?.clrTextSecondary,
                  ),
                )
              : null,
          trailing: Icon(trail),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}
