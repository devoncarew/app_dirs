import 'package:directories/directories.dart';

void main(List<String> args) {
  var dirs = Directories();

  print('base config directory: ${dirs.baseDirs.config}');
  print('base cache directory : ${dirs.baseDirs.cache}');

  var appDirs = dirs.appDirs(
    qualifier: 'dev',
    organization: 'dart-lang',
    application: 'dart',
  );

  print('app config directory : ${appDirs.config}');
  print('app cache directory  : ${appDirs.cache}');
}
