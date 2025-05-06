import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../bloc/directory/directory_bloc.dart';
import '../../../bloc/directory/directory_events.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_fab.dart';

class ScreenHero extends StatelessWidget {
  const ScreenHero({super.key, required this.rootPath});

  final String rootPath;

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final ValueNotifier<bool> hasText = ValueNotifier<bool>(false);

    searchController.addListener(() {
      hasText.value = searchController.text.isNotEmpty;
    });

    return Scaffold(
      appBar: CustomAppBar(
        rootPath: rootPath,
        controller: searchController,
        hasText: hasText,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Untangle',
                    style: TextStyle(
                      fontFamily: 'Barriecito',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFf2cdcd),
                      height: 1.1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0, top: 10),
                        child: SvgPicture.asset(
                          'lib/assets/brain.svg',
                          width: 70,
                          height: 70,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFf38ba8),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const Text(
                        'Your',
                        style: TextStyle(
                          fontFamily: 'Barriecito',
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFb4befe),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Thoughts',
                    style: TextStyle(
                      fontFamily: 'Barriecito',
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFcba6f7),
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    IconsaxPlusLinear.note_2,
                    size: 24,
                    color: Color(0xFF1e1e2e),
                  ),
                  label: const Text(
                    'Create new note',
                    style: TextStyle(
                      fontFamily: 'FiraCode',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1e1e2e),
                      wordSpacing: -3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF89b4fa),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () async {
                    final newFile = File(
                      '$rootPath/new_note_${DateTime.now().millisecondsSinceEpoch}.md',
                    );
                    await newFile.create();

                    Navigator.pushNamed(
                      context,
                      '/canvas',
                      arguments: newFile.path,
                    );

                    context
                        .read<DirectoryBloc>()
                        .add(FetchDirectory(newFile.parent.path));
                  },
                ),
                OutlinedButton.icon(
                  icon: const Icon(IconsaxPlusLinear.folder),
                  label: const Text(
                    'Open a note',
                    style: TextStyle(
                      fontFamily: 'FiraCode',
                      fontWeight: FontWeight.bold,
                      wordSpacing: -3,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFAB(rootPath: rootPath),
    );
  }
}
