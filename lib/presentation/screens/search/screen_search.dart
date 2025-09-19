// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iconsax_linear/iconsax_linear.dart';

// import '../../../bloc/directory/directory_bloc.dart';
// import '../../../bloc/directory/directory_events.dart';
// import '../../../bloc/directory/directory_states.dart';
// import '../../theme/app_themes.dart';
// import '../../widgets/context_menu.dart';
// import '../../widgets/custom_app_bar.dart';

// class ScreenSearch extends StatelessWidget {
//   const ScreenSearch({
//     super.key,
//     required this.searchQuery,
//     required this.rootPath,
//   });

//   final String searchQuery;
//   final String rootPath;

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<DirectoryBloc>().add(SearchDirectory(rootPath, searchQuery));
//     });

//     return Scaffold(
//       appBar: CustomAppBar(
//         // rootPath: rootPath,
//         // searchQuery: searchQuery,
//         // showBackButton: true,
//         leadingIcon: IconsaxLinear.activity,
//         title: 'lol',
//         trailingIcon: IconsaxLinear.activity,
//       ),
//       body: BlocBuilder<DirectoryBloc, DirectoryState>(
//         builder: (context, state) {
//           if (state.isSearching) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state.searchErrorMessage != null) {
//             return Center(
//               child: Text(
//                 'Error: ${state.searchErrorMessage}',
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           }

//           final searchResults = state.searchResults ?? [];

//           if (searchResults.isEmpty) {
//             return Center(
//               child: Text(
//                 'No results found for "$searchQuery"',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Theme.of(context)
//                       .extension<EndernoteColors>()
//                       ?.clrText
//                       .withAlpha(100),
//                 ),
//               ),
//             );
//           }

//           return ListView.builder(
//             shrinkWrap: true,
//             itemCount: searchResults.length,
//             physics: const BouncingScrollPhysics(),
//             itemBuilder: (context, index) {
//               final entityPath = searchResults[index];
//               final isFolder = Directory(entityPath).existsSync();

//               return Column(
//                 children: [
//                   GestureDetector(
//                     onSecondaryTap: () {
//                       showContextMenu(
//                         context,
//                         entityPath,
//                         isFolder,
//                         searchQuery,
//                       );
//                     },
//                     onLongPress: () {
//                       showContextMenu(
//                         context,
//                         entityPath,
//                         isFolder,
//                         searchQuery,
//                       );
//                     },
//                     child: ListTile(
//                       leading: Icon(
//                         isFolder
//                             ? (state.openFolders.contains(entityPath)
//                                 ? IconsaxLinear.folder_open
//                                 : IconsaxLinear.folder)
//                             : IconsaxLinear.task_square,
//                       ),
//                       title: Text(entityPath.split('/').last),
//                       subtitle: Text(
//                         entityPath.replaceFirst(rootPath, ''),
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Theme.of(context)
//                               .extension<EndernoteColors>()
//                               ?.clrText
//                               .withAlpha(150),
//                         ),
//                       ),
//                       onTap: () {
//                         if (isFolder) {
//                           context
//                               .read<DirectoryBloc>()
//                               .add(ToggleFolder(entityPath));
//                           if (!state.folderContents.containsKey(entityPath)) {
//                             context
//                                 .read<DirectoryBloc>()
//                                 .add(FetchDirectory(entityPath));
//                           }
//                         } else {
//                           Navigator.pushNamed(
//                             context,
//                             '/canvas',
//                             arguments: entityPath,
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                   if (isFolder && state.openFolders.contains(entityPath))
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16.0),
//                       child: _buildDirectoryList(context, entityPath, state),
//                     ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDirectoryList(
//     BuildContext context,
//     String path,
//     DirectoryState state,
//   ) {
//     final contents = state.folderContents[path] ?? [];

//     if (path == rootPath && contents.isEmpty) {
//       return Center(
//         child: Text(
//           "This folder is feeling lonely.",
//           style: TextStyle(
//             fontSize: 16,
//             color: Theme.of(context)
//                 .extension<EndernoteColors>()
//                 ?.clrText
//                 .withAlpha(100),
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const BouncingScrollPhysics(),
//       itemCount: contents.length,
//       itemBuilder: (context, index) {
//         final entityPath = contents[index];
//         final isFolder = Directory(entityPath).existsSync();

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onSecondaryTap: () {
//                 showContextMenu(
//                   context,
//                   entityPath,
//                   isFolder,
//                   searchQuery,
//                 );
//               },
//               onLongPress: () => showContextMenu(
//                 context,
//                 entityPath,
//                 isFolder,
//                 searchQuery,
//               ),
//               child: ListTile(
//                 leading: Icon(
//                   isFolder
//                       ? (state.openFolders.contains(entityPath)
//                           ? IconsaxLinear.folder_open
//                           : IconsaxLinear.folder)
//                       : IconsaxLinear.task_square,
//                 ),
//                 title: Text(entityPath.split('/').last),
//                 onTap: () {
//                   if (isFolder) {
//                     context.read<DirectoryBloc>().add(ToggleFolder(entityPath));
//                     if (!state.folderContents.containsKey(entityPath)) {
//                       context
//                           .read<DirectoryBloc>()
//                           .add(FetchDirectory(entityPath));
//                     }
//                   } else {
//                     Navigator.pushNamed(
//                       context,
//                       '/canvas',
//                       arguments: entityPath,
//                     );
//                   }
//                 },
//               ),
//             ),
//             if (isFolder && state.openFolders.contains(entityPath))
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0),
//                 child: _buildDirectoryList(context, entityPath, state),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }
