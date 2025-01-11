import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final IconData icn;
  final String title;
  final void Function()? onTap;

  const CustomTile({
    super.key,
    required this.icn,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icn),
      title: Text(title),
      onTap: onTap ?? () {},
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      height: 130,
      alignment: Alignment.center,
      child: ListView(
        children: [
          const SizedBox(height: 20),
          CustomTile(
            icn: IconsaxOutline.note_2,
            title: 'Create a new note',
            onTap: () => Navigator.pushNamed(context, '/canvas'),
          ),
          CustomTile(
            icn: IconsaxOutline.note_text,
            title: 'Open today\'s daily note',
            onTap: () => Navigator.pushNamed(context, '/canvas'),
          ),
        ],
      ),
    );
  }
}

void showCustomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => const BottomSheetContent(),
  );
}
