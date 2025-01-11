import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ficonsax/ficonsax.dart';

import '../../theme/endernote_theme.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/drawer.dart';

class ScreenHero extends StatelessWidget {
  const ScreenHero({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: showDrawer(context),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(IconsaxOutline.menu_1),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text('Endernote'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Craft your second brain',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SvgPicture.asset(
                "lib/assets/brain.svg",
                height: 150,
                color: clrText,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Create new note'),
                  ),
                  Icon(IconsaxOutline.note_2, size: 22),
                ],
              ),
              onPressed: () => Navigator.pushNamed(context, '/canvas'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Open a note'),
                  ),
                  Icon(IconsaxOutline.folder, size: 21),
                ],
              ),
              onPressed: () => Navigator.pushNamed(context, '/home'),
            ),
          ),
        ],
      ),
      floatingActionButton: IconButton.filled(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(clrText),
        ),
        icon: const Icon(
          IconsaxOutline.add,
          color: clrBase,
        ),
        onPressed: () => showCustomBottomSheet(context),
      ),
    );
  }
}
