[![package:app_dirs](https://github.com/devoncarew/app_dirs/actions/workflows/dart.yaml/badge.svg)](https://github.com/devoncarew/app_dirs/actions/workflows/dart.yaml)

A library to locate common directories using platform-specific conventions.

## What's this?

This library follows platform-specific conventions to locate common directories.
For example, the correct directory to use for application configuration files
might be `$HOME/.config/my-app` on Linux,
`$HOME/Library/Application Support/My App` on Macos, and
`%APPDATA%\My App\config` on Windows.

To use:

```dart
var appDirs = getAppDirs(application: 'FooBar App');

// Use this directory for general application configuration files.
var configDir = appDirs.config;
...

// Use this directory for cached information.
var cacheDir = appDirs.cache;
...
```

See also our [API docs](doc/app_dirs.md).

## Mac usage

### Mac standards

For MacOS defaults, we follow Apple's 
- [Standard Directories](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html)
docs. This generally puts files in subdirectories of `$HOME/Library`, which is
appropriate for most Mac apps.

### Mac alternate conventions

API clients can opt into a separate set of file location convetions for Macos.
This is done via the `preferUnixConventions` flag:

```dart
var appDirs = getAppDirs(
  application: 'FooBar App',
  preferUnixConventions: true,
);
```

This will opt that tool into using Unix style directory conventions - for
example, putting config files into `$HOME/.config/foobar-app`. While not the
Macos standard file locations, this could better match user expectations for
things like command-line tools.

## Linux usage

On Unix OSes, we follow the 
[XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).
This is generally creating directories under the user's `$HOME` directory, but
respecting various `$XDG_*` environment variable overrides.

## Windows usage

On Windows, we follow the standard Windows directory structure convention
(docuented [here](https://pureinfotech.com/list-environment-variables-windows-10/)
and elsewhere).

## BaseDirs values

This is the table of directories returned for `Directories.baseDirs`.
`AppDirs` - the recommended API for people to use - builds on top of this using
information like the application name, qualifier (`org`, `com`, ...) and
organization name.

| Property   | Linux                                     | Mac                                 | Windows |
| ---        | ---                                       | ---                                 | --- |
| home       | `$HOME`                                   | `$HOME`                             | `%USERPROFILE%` |
| cache      | `$XDG_CACHE_HOME` or `$HOME/.cache`       | `$HOME/Library/Caches`              | `%LOCALAPPDATA%` |
| config     | `$XDG_CONFIG_HOME` or `$HOME/.config`     | `$HOME/Library/Application Support` | `%APPDATA%` |
| data       | `$XDG_DATA_HOME` or `$HOME/.local/share`  | `$HOME/Library/Application Support` | `%APPDATA%` |
| dataLocal  | see data                                  | see data                            | `%LOCALAPPDATA%` |
| preference | see config                                | `$HOME/Library/Preferences`         | see config |
| state      | `$XDG_STATE_HOME` or `$HOME/.local/state` | `null`                              | `null` |

## Useful references

Specifications and documentation:
- https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
- [developer.apple.com/library/archive/documentation/FileManagement](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html)
- https://pureinfotech.com/list-environment-variables-windows-10/

Similar libraries for other platforms:
- https://github.com/dirs-dev/directories-jvm
- https://github.com/dirs-dev/directories-rs
