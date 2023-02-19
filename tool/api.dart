// Copyright (c) 2023, Devon Carew.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:path/path.dart' as p;
import 'package:dart_style/dart_style.dart';

// todo: handle references in dartdoc comments

void main(List<String> args) async {
  final collection = AnalysisContextCollection(
    includedPaths: [libDir.absolute.path],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );

  final context = collection.contexts.single;
  print('Analyzing ${context.contextRoot.root.path} ...');

  for (var file in libDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))) {
    var lib = await context.currentSession
        .getResolvedLibrary(file.absolute.path) as ResolvedLibraryResult;
    var libRelPath = p.relative(lib.element.source.fullName, from: libDir.path);
    libRelPath = p.withoutExtension(libRelPath);
    var destFile = File(p.join('doc', '$libRelPath.md'));
    generate(lib.element, destFile);
  }
}

void generate(LibraryElement library, File destFile) {
  var referencePath = p.relative(library.source.fullName, from: libDir.path);

  final buf = StringBuffer();
  buf.writeln('# $referencePath');
  buf.writeln();
  var comment = library.documentationComment;
  if (comment != null) {
    buf.writeln(stripDartdoc(comment));
    buf.writeln();
  }

  var exportNamespace = library.exportNamespace;

  var names = exportNamespace.definedNames.keys.toList()..sort();
  for (var name in names) {
    var element = exportNamespace.get(name);
    if (element is! ClassElement) continue;
    if (!isPublic(element)) continue;

    emitInterfaceElement(element, buf);
  }

  for (var name in names) {
    var element = exportNamespace.get(name);
    if (element is! EnumElement) continue;
    if (!isPublic(element)) continue;

    emitInterfaceElement(element, buf);
  }

  destFile.parent.createSync(recursive: true);
  destFile.writeAsStringSync('${buf.toString().trimRight()}\n');
}

void emitInterfaceElement(InterfaceElement element, StringBuffer buf) {
  var title = element is EnumElement ? 'Enum' : 'Class';
  var kind = element is EnumElement ? 'enum' : 'class';
  var modifiers = '';
  if (element is ClassElement) {
    modifiers = element.isAbstract ? 'abstract ' : '';
  }
  buf.writeln('## $title ${element.name}');
  buf.writeln();
  buf.writeln('```dart');
  buf.writeln('$modifiers$kind ${element.name}');
  buf.writeln('```');
  buf.writeln();
  var comment = element.documentationComment;
  if (comment != null) {
    buf.writeln(stripDartdoc(comment));
    buf.writeln();
  }

  // fields
  for (var field in element.fields) {
    if (!isPublic(field)) continue;
    if (field.isSynthetic) continue;

    var desc = element is EnumElement ? 'value ' : '';
    var fieldTypeDesc = field.type.getDisplayString(withNullability: true);
    var modifiers = field.isFinal ? 'final ' : '';
    buf.writeln('### $desc${field.name}');
    buf.writeln();
    buf.writeln('```dart');
    buf.writeln(dartFormat('$modifiers$fieldTypeDesc ${field.name}', ';'));
    buf.writeln('```');
    buf.writeln();
    var comment = field.documentationComment;
    if (comment != null) {
      buf.writeln(stripDartdoc(comment));
      buf.writeln();
    }
  }

  // constructors
  for (var ctor in element.constructors) {
    if (!isPublic(ctor)) continue;

    var typeDesc = ctor.returnType.getDisplayString(withNullability: true);
    var paramDesc = describeMethodParameters(ctor.parameters);
    var name = ctor.isGenerative ? element.name : ctor.name;
    buf.writeln('### $name()');
    buf.writeln();
    buf.writeln('```dart');
    buf.writeln(dartFormat('$typeDesc ${ctor.name}($paramDesc)', '{}'));
    buf.writeln('```');
    buf.writeln();
    var comment = ctor.documentationComment;
    if (comment != null) {
      buf.writeln(stripDartdoc(comment));
      buf.writeln();
    }
  }

  // getters and setters
  for (var accessor in element.accessors) {
    if (!isPublic(accessor)) continue;
    if (accessor.isSynthetic) continue;

    buf.writeln('### ${accessor.isGetter ? 'get' : 'set'} ${accessor.name}');
    buf.writeln();
    buf.writeln('```dart');
    if (accessor.isGetter) {
      var typeDesc =
          accessor.returnType.getDisplayString(withNullability: true);
      buf.writeln(dartFormat('$typeDesc get ${accessor.name}', '=> null;'));
    } else {
      var paramDesc = describeMethodParameters(accessor.parameters);
      buf.writeln(dartFormat('set ${accessor.name}($paramDesc)', ';'));
    }
    buf.writeln('```');
    buf.writeln();
    var comment = accessor.documentationComment;
    if (comment != null) {
      buf.writeln(stripDartdoc(comment));
      buf.writeln();
    }
  }

  // methods
  for (var method in element.methods) {
    if (!isPublic(method)) continue;

    var typeDesc = method.returnType.getDisplayString(withNullability: true);
    var paramDesc = describeMethodParameters(method.parameters);
    var modifiers = method.isStatic ? 'static ' : '';
    method.parameters;
    buf.writeln('### ${method.name}()');
    buf.writeln();
    buf.writeln('```dart');
    buf.writeln(
        modifiers + dartFormat('$typeDesc ${method.name}($paramDesc)', '{}'));
    buf.writeln('```');
    buf.writeln();
    var comment = method.documentationComment;
    if (comment != null) {
      buf.writeln(stripDartdoc(comment));
      buf.writeln();
    }
  }
}

String describeMethodParameters(List<ParameterElement> parameters) {
  var buf = StringBuffer();

  var inNamed = false;
  var inPositional = false;

  for (var param in parameters) {
    if (buf.isNotEmpty) buf.write(', ');

    if (!inNamed && !inPositional) {
      if (param.isNamed) {
        inNamed = true;
        buf.write('{ ');
      } else if (param.isOptionalPositional) {
        inPositional = true;
        buf.write('[] ');
      }
    }

    param.appendToWithoutDelimiters(buf, withNullability: true);
  }

  if (buf.length >= 68) {
    buf.write(',');
  }

  if (inNamed) {
    buf.write(' }');
  } else if (inPositional) {
    buf.write(' ]');
  }

  return buf.toString();
}

String stripDartdoc(String str) {
  return str
      .split('\n')
      .map((line) => line.trimLeft())
      .map((line) {
        if (line.startsWith('/// ')) return line.substring(4);
        if (line.startsWith('///')) return line.substring(3);
        return line;
      })
      .map((line) => line.trimRight())
      .join('\n');
}

Directory get libDir => Directory('lib');

bool isPublic(Element element) => !element.name!.startsWith('_');

String dartFormat(String fragment, String formattingSuffix) {
  var source = '''
// cut 1
$fragment$formattingSuffix
// cut 2
''';
  source = DartFormatter().format(source);
  source = source.substring(
    source.indexOf('// cut 1') + '// cut 1'.length,
    source.indexOf('// cut 2'),
  );
  source = source.trim();
  if (source.endsWith(formattingSuffix)) {
    source = source.substring(0, source.length - formattingSuffix.length);
  }
  return source.trim();
}
