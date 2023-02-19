// Copyright (c) 2023, Devon Carew.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'common.dart';

class WindowsBaseDirs extends BaseDirs {
  final Map<String, String> env;

  WindowsBaseDirs(this.env);

  @override
  String get home => env['USERPROFILE']!;

  @override
  String get cache => env['LOCALAPPDATA']!;

  @override
  String get config => env['APPDATA']!;

  @override
  String get data => env['APPDATA']!;

  @override
  String get dataLocal => env['LOCALAPPDATA']!;

  @override
  String get preference => env['APPDATA']!;

  @override
  String? get state => null;
}

class WindowsAppDirs extends AppDirs {
  late String appPath;

  WindowsAppDirs({
    required super.baseDirs,
    String? organization,
    required String application,
  }) {
    // org, Baz Corp, Foo Bar App
    //   windows: "Baz Corp/Foo Bar App"
    appPath = application;
    if (organization != null) {
      appPath = '$organization\\$appPath';
    }
  }

  @override
  String get cache => '${baseDirs.cache}\\$appPath\\cache';

  @override
  String get config => '${baseDirs.config}\\$appPath\\config';

  @override
  String get data => '${baseDirs.data}\\$appPath\\data';

  @override
  String get dataLocal => '${baseDirs.dataLocal}\\$appPath\\data';

  @override
  String get preference => '${baseDirs.preference}\\$appPath\\config';

  @override
  String? get state => null;
}
