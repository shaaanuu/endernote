import 'package:equatable/equatable.dart';

class DirectoryState extends Equatable {
  final Map<String, List<String>> folderContents;
  final Set<String> openFolders;
  final bool isLoading;
  final String? errorMessage;

  const DirectoryState({
    this.folderContents = const {},
    this.openFolders = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  DirectoryState copyWith({
    Map<String, List<String>>? folderContents,
    Set<String>? openFolders,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DirectoryState(
      folderContents: folderContents ?? this.folderContents,
      openFolders: openFolders ?? this.openFolders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        folderContents,
        openFolders,
        isLoading,
        errorMessage,
      ];
}
