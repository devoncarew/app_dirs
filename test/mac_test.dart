// Copyright (c) 2023, Devon Carew.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

@TestOn('mac-os')

import 'package:app_dirs/app_dirs.dart';
import 'package:test/test.dart';

void main() {
  final os = OperatingSystem.mac;

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
        expect(base.cache, endsWith('/Library/Caches'));
      });

      test('config', () {
        expect(base.config, endsWith('/Library/Application Support'));
      });

      test('data', () {
        expect(base.data, endsWith('/Library/Application Support'));
      });

      test('dataLocal', () {
        expect(base.dataLocal, endsWith('/Library/Application Support'));
      });

      test('preference', () {
        expect(base.preference, endsWith('/Library/Preferences'));
      });

      test('state', () {
        expect(base.state, isNull);
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
        expect(app.preference, endsWith('/Library/Preferences/FooBar'));

        app = dirs.appDirs(
          organization: 'Foo',
          application: 'Bar',
        );
        expect(app.preference, endsWith('/Library/Preferences/Foo.Bar'));

        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo',
          application: 'Bar',
        );
        expect(app.preference, endsWith('/Library/Preferences/org.Foo.Bar'));

        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo Bar',
          application: 'Baz Qux',
        );
        expect(app.preference,
            endsWith('/Library/Preferences/org.Foo-Bar.Baz-Qux'));
      });

      test('cache', () {
        expect(app.cache, endsWith('/Library/Caches/org.Foo-Bar.Baz'));
      });

      test('config', () {
        expect(app.config,
            endsWith('/Library/Application Support/org.Foo-Bar.Baz'));
      });

      test('data', () {
        expect(
            app.data, endsWith('/Library/Application Support/org.Foo-Bar.Baz'));
      });

      test('dataLocal', () {
        expect(app.dataLocal,
            endsWith('/Library/Application Support/org.Foo-Bar.Baz'));
      });

      test('preference', () {
        expect(
            app.preference, endsWith('/Library/Preferences/org.Foo-Bar.Baz'));
      });

      test('state', () {
        expect(app.state, isNull);
      });
    });

    group('app dirs preferUnixConventions', () {
      late Directories dirs;
      late AppDirs app;

      setUp(() {
        dirs = Directories(os: os);
        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo Bar',
          application: 'Baz',
          preferUnixConventions: true,
        );
      });

      test('location name', () {
        var app = dirs.appDirs(
          application: 'FooBar',
          preferUnixConventions: true,
        );
        expect(app.preference, endsWith('/.config/foobar'));

        app = dirs.appDirs(
          organization: 'Foo',
          application: 'Bar',
          preferUnixConventions: true,
        );
        expect(app.preference, endsWith('/.config/bar'));

        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo',
          application: 'Bar',
          preferUnixConventions: true,
        );
        expect(app.preference, endsWith('/.config/bar'));

        app = dirs.appDirs(
          qualifier: 'org',
          organization: 'Foo Bar',
          application: 'Baz Qux',
          preferUnixConventions: true,
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
}
