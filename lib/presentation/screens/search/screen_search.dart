import 'dart:io';

import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/directory/directory_bloc.dart';
import '../../../bloc/directory/directory_events.dart';
import '../../../bloc/directory/directory_states.dart';
import '../../theme/app_themes.dart';
import '../../widgets/custom_app_bar.dart';

class ScreenSearch extends StatelessWidget {
  const ScreenSearch({
    super.key,
    required this.searchQuery,
    required this.rootPath,
  });

  final String searchQuery;
  final String rootPath;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DirectoryBloc>().add(SearchDirectory(rootPath, searchQuery));
    });

    return Scaffold(
      appBar: CustomAppBar(
        rootPath: rootPath,
        searchQuery: searchQuery,
        showBackButton: true,
      ),
      body: BlocBuilder<DirectoryBloc, DirectoryState>(
        builder: (context, state) {
          if (state.isSearching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.searchErrorMessage != null) {
            return Center(
              child: Text(
                'Error: ${state.searchErrorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final searchResults = state.searchResults ?? [];

          if (searchResults.isEmpty) {
            return Center(
              child: Text(
                'No results found for "$searchQuery"',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .extension<EndernoteColors>()
                      ?.clrText
                      .withAlpha(100),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: searchResults.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final entityPath = searchResults[index];
              final isFolder = Directory(entityPath).existsSync();

              return ListTile(
                leading: Icon(
                  isFolder ? IconsaxOutline.folder : IconsaxOutline.task_square,
                ),
                title: Text(entityPath.split('/').last),
                subtitle: Text(
                  entityPath.replaceFirst(rootPath, ''),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .extension<EndernoteColors>()
                        ?.clrText
                        .withAlpha(150),
                  ),
                ),
                onTap: () {
                  if (isFolder) {
                    // idk what to do...
                  } else {
                    Navigator.pushNamed(
                      context,
                      '/canvas',
                      arguments: entityPath,
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
