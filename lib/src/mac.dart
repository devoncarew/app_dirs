// Copyright (c) 2023, Devon Carew.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'common.dart';

class MacBaseDirs extends BaseDirs {
  final Map<String, String> env;

  MacBaseDirs(this.env);

  @override
  String get home => env['HOME']!;

  @override
  String get cache => '$home/Library/Caches';

  @override
  String get config => '$home/Library/Application Support';

  @override
  String get data => '$home/Library/Application Support';

  @override
  String get dataLocal => '$home/Library/Application Support';

  @override
  String get preference => '$home/Library/Preferences';

  @override
  String? get state => null;
}

class MacAppDirs extends AppDirs {
  late String appPath;
  late bool preferUnixConventions;

  MacAppDirs({
    required super.baseDirs,
    String? qualifier,
    String? organization,
    required String application,
  }) {
    // org, Baz Corp, Foo Bar App
    //   mac: "org.Baz-Corp.Foo-Bar-App"
    appPath = application;
    if (organization != null) {
      appPath = '$organization.$appPath';
    }
    if (qualifier != null) {
      appPath = '$qualifier.$appPath';
    }
    appPath = appPath.replaceAll(' ', '-');
  }

  @override
  String get cache => '${baseDirs.cache}/$appPath';

  @override
  String get config => '${baseDirs.config}/$appPath';

  @override
  String get data => '${baseDirs.data}/$appPath';

  @override
  String get dataLocal => '${baseDirs.dataLocal}/$appPath';

  @override
  String get preference => '${baseDirs.preference}/$appPath';

  @override
  String? get state => null;
}
