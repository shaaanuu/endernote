abstract class FileEvents {}

class LoadFiles extends FileEvents {
  final String path;

  LoadFiles(this.path);
}
