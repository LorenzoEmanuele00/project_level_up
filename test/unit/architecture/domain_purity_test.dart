import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The domain layer is pure Dart: no Flutter (or `meta`) imports and no
/// hidden clock. Time always comes in as a parameter.
final _forbidden = RegExp(
  r'''import\s+['"]package:(flutter|meta)/'''
  r'|\bDateTime\.now\(',
);

List<String> findImpurities(String source) =>
    _forbidden.allMatches(source).map((match) => match.group(0) ?? '').toList();

void main() {
  group('findImpurities', () {
    test('detects Flutter imports', () {
      expect(
        findImpurities("import 'package:flutter/widgets.dart';"),
        isNotEmpty,
      );
      expect(
        findImpurities('import "package:flutter/material.dart";'),
        isNotEmpty,
      );
    });

    test('detects meta imports', () {
      expect(findImpurities("import 'package:meta/meta.dart';"), isNotEmpty);
    });

    test('detects the system clock', () {
      expect(findImpurities('final t = DateTime.now();'), isNotEmpty);
    });

    test('accepts pure Dart and other DateTime usage', () {
      expect(findImpurities("import 'dart:math';"), isEmpty);
      expect(
        findImpurities("import 'package:levelup/domain/enums.dart';"),
        isEmpty,
      );
      expect(findImpurities('final t = DateTime(2026, 1, 1);'), isEmpty);
      expect(findImpurities('final t = DateTime.utc(2026);'), isEmpty);
    });
  });

  group('lib/domain', () {
    test('has no Flutter import and no system clock', () {
      final domainDir = Directory('lib/domain');
      expect(domainDir.existsSync(), isTrue, reason: 'run from package root');

      final offenders = <String>[];
      for (final entity in domainDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final matches = findImpurities(entity.readAsStringSync());
        if (matches.isNotEmpty) {
          offenders.add('${entity.path}: ${matches.join(', ')}');
        }
      }

      expect(offenders, isEmpty, reason: 'domain must stay pure Dart');
    });
  });
}
