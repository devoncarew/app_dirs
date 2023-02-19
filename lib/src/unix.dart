// Copyright (c) 2023, Devon Carew.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'common.dart';

class UnixBaseDirs extends BaseDirs {
  final Map<String, String> env;

  UnixBaseDirs(this.env);

  // Linux: $HOME
  @override
  String get home => env['HOME']!;

  // cache_dir
  // $XDG_CACHE_HOME or $HOME/.cache
  @override
  String get cache => env['XDG_CACHE_HOME'] ?? '$home/.cache';

  // config_dir
  // $XDG_CONFIG_HOME or $HOME/.config
  @override
  String get config => env['XDG_CONFIG_HOME'] ?? '$home/.config';

  // data_dir
  // $XDG_DATA_HOME or $HOME/.local/share
  @override
  String get data => env['XDG_DATA_HOME'] ?? '$home/.local/share';

  // data_local_dir
  // $XDG_DATA_HOME or $HOME/.local/share
  @override
  String get dataLocal => env['XDG_DATA_HOME'] ?? '$home/.local/share';

  // preference_dir
  // $XDG_CONFIG_HOME or $HOME/.config
  @override
  String get preference => env['XDG_CONFIG_HOME'] ?? '$home/.config';

  // state_dir
  // $XDG_STATE_HOME or $HOME/.local/state
  @override
  String? get state => env['XDG_STATE_HOME'] ?? '$home/.local/state';
}

class UnixAppDirs extends AppDirs {
  late String appPath;

  UnixAppDirs({
    required super.baseDirs,
    required String application,
  }) {
    // org, Baz Corp, Foo Bar App
    //   unix: "foobar-app"
    appPath = application.toLowerCase().replaceAll(' ', '-');
  }

  // cache_dir
  // $XDG_CACHE_HOME/<project_path> or $HOME/.cache/<project_path>
  @override
  String get cache => '${baseDirs.cache}/$appPath';

  // config_dir
  // $XDG_CONFIG_HOME/<project_path> or $HOME/.config/<project_path>
  @override
  String get config => '${baseDirs.config}/$appPath';

  // data_dir
  // $XDG_DATA_HOME/<project_path> or $HOME/.local/share/<project_path>
  @override
  String get data => '${baseDirs.data}/$appPath';

  // data_local_dir
  // $XDG_DATA_HOME/<project_path> or $HOME/.local/share/<project_path>
  @override
  String get dataLocal => '${baseDirs.dataLocal}/$appPath';

  // preference_dir
  // $XDG_CONFIG_HOME/<project_path> or $HOME/.config/<project_path>
  @override
  String get preference => '${baseDirs.preference}/$appPath';

  // state_dir
  // Some($XDG_STATE_HOME/<project_path>) or $HOME/.local/state/<project_path>
  @override
  String? get state => '${baseDirs.state}/$appPath';
}
