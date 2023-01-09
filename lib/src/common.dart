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
/// [Directories.getAppDirectories] and [AppDirs].
abstract class BaseDirs {
  /// The user's home directory. On Unix like systems, this will be `$HOME`. On
  /// Windows, this will be `$USERPROFILE`.
  String get home;

  /// todo: doc
  String get cache;

  /// todo: doc
  String get config;

  /// todo: doc
  String get data;

  /// todo: doc
  String get dataLocal;

  /// todo: doc
  String get preference;

  /// todo: doc
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

  /// todo: doc
  String get cache;

  /// todo: doc
  String get config;

  /// todo: doc
  String get data;

  /// todo: doc
  String get dataLocal;

  /// todo: doc
  String get preference;

  /// todo: doc
  String? get state;
}

// todo: for docs

// class BaseDirectories {
//   final Map<String, String> env;
//   final OperatingSystem os;

//   BaseDirectories(this.env, this.os);

//   // home
//   // Linux: $HOME
//   // Windows: {FOLDERID_Profile} (USERPROFILE ?)
//   // Mac: $HOME
//   String get home {
//     switch (os) {
//       case OperatingSystem.unix:
//         return env['HOME']!;
//       case OperatingSystem.windows:
//         return env['USERPROFILE']!;
//       case OperatingSystem.mac:
//         return env['HOME']!;
//     }
//   }

//   // cache_dir
//   // $XDG_CACHE_HOME or $HOME/.cache
//   // {FOLDERID_LocalAppData}
//   // $HOME/Library/Caches
//   String get cache {
//     switch (os) {
//       case OperatingSystem.unix:
//         return env['XDG_CACHE_HOME'] ?? p.join(home, '.cache');
//       case OperatingSystem.windows:
//         return env['LOCALAPPDATA']!;
//       case OperatingSystem.mac:
//         return p.join(home, 'Library', 'Caches');
//     }
//   }

//   // config_dir
//   // $XDG_CONFIG_HOME or $HOME/.config
//   // {FOLDERID_RoamingAppData}
//   // $HOME/Library/Application Support
//   String get config {
//     switch (os) {
//       case OperatingSystem.unix:
//         return env['XDG_CONFIG_HOME'] ?? p.join(home, '.config');
//       case OperatingSystem.windows:
//         return env['APPDATA']!;
//       case OperatingSystem.mac:
//         return p.join(home, 'Library', 'Application Support');
//     }
//   }

//   // data_dir
//   // $XDG_DATA_HOME or $HOME/.local/share
//   // {FOLDERID_RoamingAppData}
//   // $HOME/Library/Application Support
//   String get data {
//     switch (os) {
//       case OperatingSystem.unix:
//         return env['XDG_DATA_HOME'] ?? p.join(home, '.local', 'share');
//       case OperatingSystem.windows:
//         return env['APPDATA']!;
//       case OperatingSystem.mac:
//         return p.join(home, 'Library', 'Application Support');
//     }
//   }

//   // data_local_dir
//   // $XDG_DATA_HOME or $HOME/.local/share
//   // {FOLDERID_LocalAppData}
//   // $HOME/Library/Application Support
//   String get dataLocal {
//     switch (os) {
//       case OperatingSystem.unix:
//         return env['XDG_DATA_HOME'] ?? p.join(home, '.local', 'share');
//       case OperatingSystem.windows:
//         return env['LOCALAPPDATA']!;
//       case OperatingSystem.mac:
//         return p.join(home, 'Library', 'Application Support');
//     }
//   }

//   // preference_dir
//   // $XDG_CONFIG_HOME or $HOME/.config
//   // {FOLDERID_RoamingAppData}
//   // $HOME/Library/Preferences
//   String get preference {
//     switch (os) {
//       case OperatingSystem.unix:
//         return env['XDG_CONFIG_HOME'] ?? p.join(home, '.config');
//       case OperatingSystem.windows:
//         return env['APPDATA']!;
//       case OperatingSystem.mac:
//         return p.join(home, 'Library', 'Preferences');
//     }
//   }

//   // state_dir
//   // Some($XDG_STATE_HOME) or Some($HOME/.local/state)
//   // None
//   // None
//   String? get state {
//     switch (os) {
//       case OperatingSystem.unix:
//         return env['XDG_STATE_HOME'] ?? p.join(home, '.local', 'state');
//       case OperatingSystem.windows:
//         return null;
//       case OperatingSystem.mac:
//         return null;
//     }
//   }
// }

// class AppDirectories {
//   final BaseDirectories base;
//   final OperatingSystem os;
//   final bool preferUnixConventions;

//   final String? qualifier;
//   final String? organization;
//   final String application;

//   late String _appPath;

//   AppDirectories({
//     required this.base,
//     required this.os,
//     this.preferUnixConventions = false,
//     this.qualifier,
//     this.organization,
//     required this.application,
//   }) {
//     // org, Baz Corp, Foo Bar App
//     //   unix: "foobar-app"
//     //   windows: "Baz Corp/Foo Bar App"
//     //   mac: "org.Baz-Corp.Foo-Bar-App"
//     if (os == OperatingSystem.windows) {
//       _appPath = application;
//       if (organization != null) {
//         _appPath = '$organization${p.separator}$_appPath';
//       }
//     } else if (os == OperatingSystem.unix || preferUnixConventions) {
//       _appPath = application.toLowerCase().replaceAll(' ', '-');
//     } else {
//       _appPath = application;
//       if (organization != null) {
//         _appPath = '$organization.$_appPath';
//       }
//       if (qualifier != null) {
//         _appPath = '$qualifier.$_appPath';
//       }
//       _appPath = _appPath.replaceAll(' ', '-');
//     }
//   }

//   // cache_dir
//   // $XDG_CACHE_HOME/<project_path> or $HOME/.cache/<project_path>
//   // {FOLDERID_LocalAppData}/<project_path>/cache
//   // $HOME/Library/Caches/<project_path>
//   String get cache {
//     if (os == OperatingSystem.windows) {
//       return p.join(base.cache, _appPath, 'cache');
//     } else if (os == OperatingSystem.unix || preferUnixConventions) {
//       return p.join(base.cache, _appPath);
//     } else {
//       return p.join(base.cache, _appPath);
//     }
//   }

//   // config_dir
//   // $XDG_CONFIG_HOME/<project_path> or $HOME/.config/<project_path>
//   // {FOLDERID_RoamingAppData}/<project_path>/config
//   // $HOME/Library/Application Support/<project_path>
//   String get config {
//     if (os == OperatingSystem.windows) {
//       return p.join(base.config, _appPath, 'config');
//     } else if (os == OperatingSystem.unix || preferUnixConventions) {
//       return p.join(base.config, _appPath);
//     } else {
//       return p.join(base.config, _appPath);
//     }
//   }

//   // data_dir
//   // $XDG_DATA_HOME/<project_path> or $HOME/.local/share/<project_path>
//   // {FOLDERID_RoamingAppData}/<project_path>/data
//   // $HOME/Library/Application Support/<project_path>
//   String get data {
//     if (os == OperatingSystem.windows) {
//       return p.join(base.data, _appPath, 'data');
//     } else if (os == OperatingSystem.unix || preferUnixConventions) {
//       return p.join(base.data, _appPath);
//     } else {
//       return p.join(base.data, _appPath);
//     }
//   }

//   // data_local_dir
//   // $XDG_DATA_HOME/<project_path> or $HOME/.local/share/<project_path>
//   // {FOLDERID_LocalAppData}/<project_path>/data
//   // $HOME/Library/Application Support/<project_path>
//   String get dataLocal {
//     if (os == OperatingSystem.windows) {
//       return p.join(base.dataLocal, _appPath, 'data');
//     } else if (os == OperatingSystem.unix || preferUnixConventions) {
//       return p.join(base.data, _appPath);
//     } else {
//       return p.join(base.data, _appPath);
//     }
//   }

//   // preference_dir
//   // $XDG_CONFIG_HOME/<project_path> or $HOME/.config/<project_path>
//   // {FOLDERID_RoamingAppData}/<project_path>/config
//   // $HOME/Library/Preferences/<project_path>
//   String get preference {
//     if (os == OperatingSystem.windows) {
//       return p.join(base.preference, _appPath, 'config');
//     } else if (os == OperatingSystem.unix || preferUnixConventions) {
//       return p.join(base.preference, _appPath);
//     } else {
//       return p.join(base.preference, _appPath);
//     }
//   }

//   // state_dir
//   // Some($XDG_STATE_HOME/<project_path>) or $HOME/.local/state/<project_path>
//   // None
//   // None
//   String? get state {
//     if (os == OperatingSystem.windows) {
//       return null;
//     } else if (os == OperatingSystem.unix || preferUnixConventions) {
//       return p.join(base.state!, _appPath);
//     } else {
//       return null;
//     }
//   }
// }
