import 'dart:io';

abstract class FileStates {}

class FileInitial extends FileStates {}

class FileLoading extends FileStates {}

class FileLoaded extends FileStates {
  final List<FileSystemEntity> files;

  FileLoaded(this.files);
}

class FileError extends FileStates {
  final String msg;

  FileError(this.msg);
}
