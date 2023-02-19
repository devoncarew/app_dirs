// Copyright (c) 2023, Devon Carew.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// A library to locate common directories using platform-specific conventions.
///
/// To use:
///
/// ```
/// var appDirs = getAppDirs(application: 'FooBar App');
/// var configDir = appDirs.config;
/// ...
/// ```

import 'dart:io' as io;

import 'src/common.dart';
import 'src/mac.dart';
import 'src/unix.dart';
import 'src/windows.dart';

export 'src/common.dart' show BaseDirs, AppDirs, OperatingSystem;

/// Returns the directory locations for the current platform's conventions,
/// factoring in information like the application name.
///
/// The [application], [qualifier] and [organization] information is used to
/// construct the correct app path. For instance, in Unix that path might be
/// `'foobar-app'`, on Windows `'Baz Corp/Foo Bar App'` and on MacOS
/// `'org.Baz-Corp.Foo-Bar-App'`.
///
/// The [preferUnixConventions] param is used to configure the MacOS directory
/// conventions used. This library defaults to the standard Mac conventions -
/// an app's config directory may look something like
/// `~/Library/Application support/org.Baz-Corp.Foo-Bar-App`. However, for some
/// apps - like command-line tools - a Unix convention may be more familiar to
/// users. Specify `preferUnixConventions: true` to use thos conventions
/// instead (the above path may then look something like
/// `~/.config/foobar-app`).
AppDirs getAppDirs({
  String? qualifier,
  String? organization,
  required String application,
  bool preferUnixConventions = false,
}) {
  return Directories().appDirs(
    qualifier: qualifier,
    organization: organization,
    application: application,
    preferUnixConventions: preferUnixConventions,
  );
}

/// The main entry-point to `package:app_dirs`.
///
/// Most callers will use [appDirs]; this returns the correct platform
/// directories to use given your application metadata.
///
/// [baseDirs] returns the base directories for the current platform. These are
/// the standard directories for the platform's conventions, but without taking
/// into account things like the application name.
class Directories {
  /// The base directories for the current platform. These are the standard
  /// directories for the platform's conventions, but without taking into
  /// account things like the application name.
  ///
  /// Most applications should instead use [Directories.getAppDirectories] to
  /// locate directories. That will take in account things like the application
  /// and organization name, and will locate directories using the platform's
  /// conventions.
  late final BaseDirs baseDirs;

  late final Map<String, String> _env;
  late final OperatingSystem _os;

  /// Create a new [Directories] instance.
  ///
  /// The [env] and [os] parameters allow you to override the system defaults.
  /// This is generally only useful for testing.
  Directories({
    Map<String, String>? env,
    OperatingSystem? os,
  })  : _os = os ?? OperatingSystem.detect(),
        _env = env ?? io.Platform.environment {
    switch (_os) {
      case OperatingSystem.unix:
        baseDirs = UnixBaseDirs(_env);
        break;
      case OperatingSystem.windows:
        baseDirs = WindowsBaseDirs(_env);
        break;
      case OperatingSystem.mac:
        baseDirs = MacBaseDirs(_env);
        break;
    }
  }

  /// Returns the directory locations for the current platform's conventions,
  /// factoring in information like the application name.
  ///
  /// The [application], [qualifier] and [organization] information is used to
  /// construct the correct app path. For instance, in Unix that path might be
  /// `'foobar-app'`, on Windows `'Baz Corp/Foo Bar App'` and on MacOS
  /// `'org.Baz-Corp.Foo-Bar-App'`.
  ///
  /// The [preferUnixConventions] param is used to configure the MacOS directory
  /// conventions used. This library defaults to the standard Mac conventions -
  /// an app's config directory may look something like
  /// `~/Library/Application support/org.Baz-Corp.Foo-Bar-App`. However, for some
  /// apps - like command-line tools - a Unix convention may be more familiar to
  /// users. Specify `preferUnixConventions: true` to use thos conventions
  /// instead (the above path may then look something like
  /// `~/.config/foobar-app`).
  AppDirs appDirs({
    String? qualifier,
    String? organization,
    required String application,
    bool preferUnixConventions = false,
  }) {
    switch (_os) {
      case OperatingSystem.unix:
        return UnixAppDirs(
          baseDirs: baseDirs,
          application: application,
        );
      case OperatingSystem.windows:
        return WindowsAppDirs(
          baseDirs: baseDirs,
          organization: organization,
          application: application,
        );
      case OperatingSystem.mac:
        if (preferUnixConventions) {
          return UnixAppDirs(
            baseDirs: UnixBaseDirs(_env),
            application: application,
          );
        } else {
          return MacAppDirs(
            baseDirs: baseDirs,
            qualifier: qualifier,
            organization: organization,
            application: application,
          );
        }
    }
  }

  @override
  String toString() => 'Directories(${_os.name})';
}
