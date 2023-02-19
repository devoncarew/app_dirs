// Copyright (c) 2023, Devon Carew.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

@TestOn('linux')

import 'dart:io' as io;

import 'package:app_dirs/app_dirs.dart';
import 'package:test/test.dart';

String get home => io.Platform.environment['HOME']!;

void main() {
  final os = OperatingSystem.unix;

  group(os.name, () {
    group('base dirs', () {
      late Directories dirs;
      late BaseDirs base;

      setUp(() {
        dirs = Directories(os: os);
        base = dirs.baseDirs;
      });

      test('home', () {
        expect(base.home, isNotEmpty);
      });

      test('cache', () {
        expect(base.cache, endsWith('/.cache'));
      });

      test('config', () {
        expect(base.config, endsWith('/.config'));
      });

      test('data', () {
        expect(base.data, endsWith('/.local/share'));
      });

      test('dataLocal', () {
        expect(base.dataLocal, endsWith('/.local/share'));
      });

      test('preference', () {
        expect(base.preference, endsWith('/.config'));
      });

      test('state', () {
        expect(base.state, endsWith('/.local/state'));
      });
    });

    group('app dirs', () {
      late Directories dirs;
      late AppDirs app;

      setUp(() {
        dirs = Directories(os: os);
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
        expect(app.preference, endsWith('/.config/foobar'));

        app = dirs.appDirs(
          organization: 'Foo',
          application: 'Bar',
        );
        expect(app.preference, endsWith('/.config/bar'));

        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo',
          application: 'Bar',
        );
        expect(app.preference, endsWith('/.config/bar'));

        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo Bar',
          application: 'Baz Qux',
        );
        expect(app.preference, endsWith('/.config/baz-qux'));
      });

      test('cache', () {
        expect(app.cache, endsWith('/.cache/baz'));
      });

      test('config', () {
        expect(app.config, endsWith('/.config/baz'));
      });

      test('data', () {
        expect(app.data, endsWith('/.local/share/baz'));
      });

      test('dataLocal', () {
        expect(app.dataLocal, endsWith('/.local/share/baz'));
      });

      test('preference', () {
        expect(app.preference, endsWith('/.config/baz'));
      });

      test('state', () {
        expect(app.state, endsWith('/.local/state/baz'));
      });
    });
  });

  group('${os.name} xdg', () {
    group('base dirs', () {
      late Directories dirs;
      late BaseDirs base;

      final Map<String, String> xdgOverrides = {
        'HOME': home,
        'XDG_CACHE_HOME': '$home/xdg/cache',
        'XDG_CONFIG_HOME': '$home/xdg/config',
        'XDG_DATA_HOME': '$home/xdg/data',
        'XDG_STATE_HOME': '$home/xdg/state',
      };

      setUp(() {
        dirs = Directories(os: os, env: xdgOverrides);
        base = dirs.baseDirs;
      });

      test('home', () {
        expect(base.home, isNotEmpty);
      });

      test('cache', () {
        expect(base.cache, endsWith('/xdg/cache'));
      });

      test('config', () {
        expect(base.config, endsWith('/xdg/config'));
      });

      test('data', () {
        expect(base.data, endsWith('/xdg/data'));
      });

      test('dataLocal', () {
        expect(base.dataLocal, endsWith('/xdg/data'));
      });

      test('preference', () {
        expect(base.preference, endsWith('/xdg/config'));
      });

      test('state', () {
        expect(base.state, endsWith('/xdg/state'));
      });
    });

    group('app dirs', () {
      late Directories dirs;
      late AppDirs app;

      final Map<String, String> xdgOverrides = {
        'HOME': home,
        'XDG_CACHE_HOME': '$home/xdg/cache',
        'XDG_CONFIG_HOME': '$home/xdg/config',
        'XDG_DATA_HOME': '$home/xdg/data',
        'XDG_STATE_HOME': '$home/xdg/state',
      };

      setUp(() {
        dirs = Directories(os: os, env: xdgOverrides);
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
        expect(app.preference, endsWith('/xdg/config/foobar'));

        app = dirs.appDirs(
          organization: 'Foo',
          application: 'Bar',
        );
        expect(app.preference, endsWith('/xdg/config/bar'));

        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo',
          application: 'Bar',
        );
        expect(app.preference, endsWith('/xdg/config/bar'));

        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo Bar',
          application: 'Baz Qux',
        );
        expect(app.preference, endsWith('/xdg/config/baz-qux'));
      });

      test('cache', () {
        expect(app.cache, endsWith('/xdg/cache/baz'));
      });

      test('config', () {
        expect(app.config, endsWith('/xdg/config/baz'));
      });

      test('data', () {
        expect(app.data, endsWith('/xdg/data/baz'));
      });

      test('dataLocal', () {
        expect(app.dataLocal, endsWith('/xdg/data/baz'));
      });

      test('preference', () {
        expect(app.preference, endsWith('/xdg/config/baz'));
      });

      test('state', () {
        expect(app.state, endsWith('/xdg/state/baz'));
      });
    });
  });
}
