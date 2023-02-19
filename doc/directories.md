# directories.dart

A library to locate common directories using platform-specific conventions.

To use:

```
var appDirs = Directories().appDirs(application: 'FooBar App');
var cacheDir = appDirs.cache;
var configDir = appDirs.config;
```

## Class AppDirs

```dart
abstract class AppDirs
```

The directory locations for the current platform's conventions. This class
factors in information like the application and company name.

### baseDirs

```dart
final BaseDirs baseDirs
```

The base directories backing this [AppDirs] instance.

### AppDirs()

```dart
AppDirs({BaseDirs baseDirs})
```

### get cache

```dart
String get cache
```

The directory relative to which user-specific non-essential data files
should be stored.

### get config

```dart
String get config
```

The directory for user-specific configuration files.

### get data

```dart
String get data
```

The directory for user-specific data files.

### get dataLocal

```dart
String get dataLocal
```

The directory for local, user-specific data files.

On Windows, this will return a directory relative to `%LOCALAPPDATA%`
(vs. `%APPDATA%` for [data]).

### get preference

```dart
String get preference
```

The directory for user preference data.

### get state

```dart
String? get state
```

The directory for user-specific state data.

This is data that should persist between (application) restarts, but that
is not important or portable enough to the user that it should be stored
in [data]. Some examples are actions history (recently used files, ...) or
current state of the application that can be reused on a restart (window
layout, open files, ...).

## Class BaseDirs

```dart
abstract class BaseDirs
```

The base directories for the current platform. These are the standard
directories for the platform's conventions, but without taking into account
things like the application name.

For directory locations that take application name into account, see
[Directories.appDirs] and [AppDirs].

### BaseDirs()

```dart
BaseDirs()
```

### get home

```dart
String get home
```

The user's home directory. On Unix like systems, this will be `$HOME`. On
Windows, this will be `$USERPROFILE`.

### get cache

```dart
String get cache
```

The directory relative to which user-specific non-essential data files
should be stored.

### get config

```dart
String get config
```

The directory for user-specific configuration files.

### get data

```dart
String get data
```

The directory for user-specific data files.

### get dataLocal

```dart
String get dataLocal
```

The directory for local, user-specific data files.

On Windows, this will return `%LOCALAPPDATA%` (vs. `%APPDATA%` for
[data]).

### get preference

```dart
String get preference
```

The directory for user preference data.

### get state

```dart
String? get state
```

The directory for user-specific state data.

This is data that should persist between (application) restarts, but that
is not important or portable enough to the user that it should be stored
in [data]. Some examples are actions history (recently used files, ...) or
current state of the application that can be reused on a restart (window
layout, open files, ...).

## Class Directories

```dart
class Directories
```

The main entry-point to `package:directories`.

Most callers will use [appDirs]; this returns the correct platform
directories to use given your application metadata.

[baseDirs] returns the base directories for the current platform. These are
the standard directories for the platform's conventions, but without taking
into account things like the application name.

### baseDirs

```dart
final BaseDirs baseDirs
```

The base directories for the current platform. These are the standard
directories for the platform's conventions, but without taking into
account things like the application name.

Most applications should instead use [Directories.getAppDirectories] to
locate directories. That will take in account things like the application
and organization name, and will locate directories using the platform's
conventions.

### Directories()

```dart
Directories({Map<String, String>? env, OperatingSystem? os})
```

Create a new [Directories] instance.

The [env] and [os] parameters allow you to override the system defaults.
This is generally only useful for testing.

### appDirs()

```dart
AppDirs appDirs({
  String? qualifier,
  String? organization,
  String application,
  bool preferUnixConventions = false,
})
```

The directory locations for the current platform's conventions. This
factors in information like the application and company name.

The [application], [qualifier] and [organization] information is used to
construct the correct app path. For instance, in Unix that path might be
`'foobar-app'`, on Windows `'Baz Corp/Foo Bar App'` and on MacOS
`'org.Baz-Corp.Foo-Bar-App'`.

The [preferUnixConventions] param is used to configure the MacOS directory
conventions used. This library defaults to the standard Mac conventions -
an app's config directory may look something like
`~/Library/Application support/org.Baz-Corp.Foo-Bar-App`. However, for some
apps - like command-line tools - a Unix convention may be more familiar to
users. Specify `preferUnixConventions: true` to use thos conventions
instead (the above path may then look something like
`~/.config/foobar-app`).

### toString()

```dart
String toString()
```

## Enum OperatingSystem

```dart
enum OperatingSystem
```

The operating system to assume for directory conventions; passed as a param
to [Directories].

### value unix

```dart
OperatingSystem unix
```

Unix-like operating systems (like Linux).

### value windows

```dart
OperatingSystem windows
```

Windows.

### value mac

```dart
OperatingSystem mac
```

MacOS.

### OperatingSystem()

```dart
OperatingSystem()
```

### detect()

```dart
static OperatingSystem detect()
```

Return the correct [OperatingSystem] enum for the current platform.
