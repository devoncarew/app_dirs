// Copyright (c) 2023, Devon Carew.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

@TestOn('windows')

import 'dart:io' as io;

import 'package:app_dirs/app_dirs.dart';
import 'package:test/test.dart';

String get home => io.Platform.environment['HOME']!;

// We don't normally override the env vars, but we occasionally want to run
// these tests on non-Windows platforms.
Map<String, String>? maybeOverrideEnvs() {
  if (io.Platform.isWindows) return null;

  return {
    'USERPROFILE': 'C:\\Users\\TestUser',
    'APPDATA': 'C:\\Users\\TestUser\\AppData',
    'LOCALAPPDATA': 'C:\\Users\\TestUser\\AppData\\Local',
  };
}

void main() {
  final os = OperatingSystem.windows;

  group(os.name, () {
    group('base dirs', () {
      late Directories dirs;
      late BaseDirs base;

      setUp(() {
        dirs = Directories(os: os, env: maybeOverrideEnvs());
        base = dirs.baseDirs;
      });

      test('home', () {
        expect(base.home, isNotEmpty);
      });

      test('cache', () {
        expect(base.cache, isNotNull);
      });

      test('config', () {
        expect(base.config, isNotNull);
      });

      test('data', () {
        expect(base.data, isNotNull);
      });

      test('dataLocal', () {
        expect(base.dataLocal, isNotNull);
      });

      test('preference', () {
        expect(base.preference, isNotNull);
      });

      test('state', () {
        expect(base.state, isNull);
      });
    });

    group('app dirs', () {
      late Directories dirs;
      late AppDirs app;

      setUp(() {
        dirs = Directories(os: os, env: maybeOverrideEnvs());
        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo Bar',
          application: 'Baz',
        );
      });

      test('location name', () {
        var app = dirs.appDirs(
          application: 'FooBar',
        );
        expect(app.preference, contains('\\FooBar\\'));

        app = dirs.appDirs(
          organization: 'Foo',
          application: 'Bar',
        );
        expect(app.preference, contains('\\Foo\\Bar\\'));

        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo',
          application: 'Bar',
        );
        expect(app.preference, contains('\\Foo\\Bar\\'));

        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo Bar',
          application: 'Baz Qux',
        );
        expect(app.preference, contains('\\Foo Bar\\Baz Qux\\'));
      });

      test('cache', () {
        expect(app.cache, endsWith('\\Baz\\cache'));
      });

      test('config', () {
        expect(app.config, endsWith('\\Baz\\config'));
      });

      test('data', () {
        expect(app.data, endsWith('\\Baz\\data'));
      });

      test('dataLocal', () {
        expect(app.dataLocal, endsWith('\\Baz\\data'));
      });

      test('preference', () {
        expect(app.preference, endsWith('\\Baz\\config'));
      });

      test('state', () {
        expect(app.state, isNull);
      });
    });
  });
}
