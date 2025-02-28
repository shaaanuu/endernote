import 'package:equatable/equatable.dart';

class DirectoryState extends Equatable {
  final Map<String, List<String>> folderContents;
  final Set<String> openFolders;
  final bool isLoading;
  final String? errorMessage;
  final bool isSearching;
  final List<String>? searchResults;
  final String? searchErrorMessage;

  const DirectoryState({
    this.folderContents = const {},
    this.openFolders = const {},
    this.isLoading = false,
    this.errorMessage,
    this.isSearching = false,
    this.searchResults,
    this.searchErrorMessage,
  });

  DirectoryState copyWith({
    Map<String, List<String>>? folderContents,
    Set<String>? openFolders,
    bool? isLoading,
    String? errorMessage,
    bool? isSearching,
    List<String>? searchResults,
    String? searchErrorMessage,
  }) {
    return DirectoryState(
      folderContents: folderContents ?? this.folderContents,
      openFolders: openFolders ?? this.openFolders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSearching: isSearching ?? this.isSearching,
      searchResults: searchResults ?? this.searchResults,
      searchErrorMessage: searchErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        folderContents,
        openFolders,
        isLoading,
        errorMessage,
        isSearching,
        searchResults,
        searchErrorMessage,
      ];
}
