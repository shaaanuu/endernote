import 'package:equatable/equatable.dart';

abstract class DirectoryEvent extends Equatable {
  const DirectoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchDirectory extends DirectoryEvent {
  final String path;

  const FetchDirectory(this.path);

  @override
  List<Object?> get props => [path];
}

class ToggleFolder extends DirectoryEvent {
  final String path;

  const ToggleFolder(this.path);

  @override
  List<Object?> get props => [path];
}

class SearchDirectory extends DirectoryEvent {
  final String rootPath;
  final String query;

  const SearchDirectory(this.rootPath, this.query);

  @override
  List<Object?> get props => [rootPath, query];
}
