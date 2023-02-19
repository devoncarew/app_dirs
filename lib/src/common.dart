// Copyright (c) 2023, Devon Carew.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:io' as io;

/// The operating system to assume for directory conventions; passed as a param
/// to [Directories].
enum OperatingSystem {
  /// Unix-like operating systems (like Linux).
  unix,

  /// Windows.
  windows,

  /// MacOS.
  mac;

  /// Return the correct [OperatingSystem] enum for the current platform.
  static OperatingSystem detect() {
    if (io.Platform.isWindows) return windows;
    if (io.Platform.isMacOS) return mac;
    return unix;
  }
}

/// The base directories for the current platform. These are the standard
/// directories for the platform's conventions, but without taking into account
/// things like the application name.
///
/// For directory locations that take application name into account, see
/// [Directories.appDirs] and [AppDirs].
abstract class BaseDirs {
  /// The user's home directory. On Unix like systems, this will be `$HOME`. On
  /// Windows, this will be `$USERPROFILE`.
  String get home;

  /// The directory relative to which user-specific non-essential data files
  /// should be stored.
  String get cache;

  /// The directory for user-specific configuration files.
  String get config;

  /// The directory for user-specific data files.
  String get data;

  /// The directory for local, user-specific data files.
  ///
  /// On Windows, this will return `%LOCALAPPDATA%` (vs. `%APPDATA%` for
  /// [data]).
  String get dataLocal;

  /// The directory for user preference data.
  String get preference;

  /// The directory for user-specific state data.
  ///
  /// This is data that should persist between (application) restarts, but that
  /// is not important or portable enough to the user that it should be stored
  /// in [data]. Some examples are actions history (recently used files, ...) or
  /// current state of the application that can be reused on a restart (window
  /// layout, open files, ...).
  String? get state;
}

/// The directory locations for the current platform's conventions. This class
/// factors in information like the application and company name.
abstract class AppDirs {
  /// The base directories backing this [AppDirs] instance.
  final BaseDirs baseDirs;

  AppDirs({
    required this.baseDirs,
  });

  /// The directory relative to which user-specific non-essential data files
  /// should be stored.
  String get cache;

  /// The directory for user-specific configuration files.
  String get config;

  /// The directory for user-specific data files.
  String get data;

  /// The directory for local, user-specific data files.
  ///
  /// On Windows, this will return a directory relative to `%LOCALAPPDATA%`
  /// (vs. `%APPDATA%` for [data]).
  String get dataLocal;

  /// The directory for user preference data.
  String get preference;

  /// The directory for user-specific state data.
  ///
  /// This is data that should persist between (application) restarts, but that
  /// is not important or portable enough to the user that it should be stored
  /// in [data]. Some examples are actions history (recently used files, ...) or
  /// current state of the application that can be reused on a restart (window
  /// layout, open files, ...).
  String? get state;
}
