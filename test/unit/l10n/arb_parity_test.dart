import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _placeholder = RegExp(r'\{(\w+)\}');

Set<String> _placeholders(String message) =>
    _placeholder.allMatches(message).map((m) => m.group(1)!).toSet();

/// Compares the template (it) with a translation (en) and returns one
/// human-readable issue per problem. An empty list means the files agree.
List<String> arbParityIssues(Map<String, dynamic> it, Map<String, dynamic> en) {
  bool isMessage(String key) => !key.startsWith('@');
  final itKeys = it.keys.where(isMessage).toSet();
  final enKeys = en.keys.where(isMessage).toSet();
  final issues = <String>[];

  for (final key in itKeys.difference(enKeys)) {
    issues.add('$key: missing in en');
  }
  for (final key in enKeys.difference(itKeys)) {
    issues.add('$key: only in en');
  }
  for (final key in itKeys.intersection(enKeys)) {
    final itMessage = it[key];
    final enMessage = en[key];
    if (itMessage is! String || itMessage.trim().isEmpty) {
      issues.add('$key: empty message in it');
    }
    if (enMessage is! String || enMessage.trim().isEmpty) {
      issues.add('$key: empty message in en');
    }
    if (itMessage is String &&
        enMessage is String &&
        !_samePlaceholders(itMessage, enMessage)) {
      issues.add('$key: different placeholders');
    }
  }
  for (final key in itKeys) {
    final meta = it['@$key'];
    final description = meta is Map ? meta['description'] : null;
    if (description is! String || description.trim().isEmpty) {
      issues.add('$key: missing @description in template');
    }
  }
  return issues..sort();
}

bool _samePlaceholders(String a, String b) {
  final left = _placeholders(a);
  final right = _placeholders(b);
  return left.length == right.length && left.containsAll(right);
}

Map<String, dynamic> _template(Map<String, dynamic> messages) => {
  for (final entry in messages.entries) ...{
    entry.key: entry.value,
    '@${entry.key}': {'description': 'd'},
  },
};

void main() {
  group('arbParityIssues', () {
    test('accepts matching files', () {
      final it = _template({'hello': 'Ciao {name}'});
      final en = {'hello': 'Hello {name}'};

      expect(arbParityIssues(it, en), isEmpty);
    });

    test('ignores @@locale and metadata entries', () {
      final it = {
        ..._template({'a': 'A'}),
        '@@locale': 'it',
      };
      final en = {'a': 'A', '@@locale': 'en'};

      expect(arbParityIssues(it, en), isEmpty);
    });

    test('reports a key missing in en', () {
      final issues = arbParityIssues(_template({'a': 'A', 'b': 'B'}), {
        'a': 'A',
      });

      expect(issues, ['b: missing in en']);
    });

    test('reports a key only in en', () {
      final issues = arbParityIssues(_template({'a': 'A'}), {
        'a': 'A',
        'c': 'C',
      });

      expect(issues, ['c: only in en']);
    });

    test('reports different placeholders', () {
      final issues = arbParityIssues(_template({'a': 'Ciao {name}'}), {
        'a': 'Hello {user}',
      });

      expect(issues, ['a: different placeholders']);
    });

    test('reports a placeholder present on one side only', () {
      final issues = arbParityIssues(_template({'a': 'Ciao'}), {
        'a': 'Hello {name}',
      });

      expect(issues, ['a: different placeholders']);
    });

    test('reports empty messages', () {
      final issues = arbParityIssues(_template({'a': ''}), {'a': '  '});

      expect(issues, ['a: empty message in en', 'a: empty message in it']);
    });

    test('reports a missing or blank @description in the template', () {
      final noMeta = arbParityIssues({'a': 'A'}, {'a': 'A'});
      final blank = arbParityIssues(
        {
          'a': 'A',
          '@a': {'description': ' '},
        },
        {'a': 'A'},
      );

      expect(noMeta, ['a: missing @description in template']);
      expect(blank, ['a: missing @description in template']);
    });
  });

  group('lib/l10n ARB files', () {
    test('app_it.arb and app_en.arb are in parity', () {
      Map<String, dynamic> read(String path) =>
          jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

      final issues = arbParityIssues(
        read('lib/l10n/app_it.arb'),
        read('lib/l10n/app_en.arb'),
      );

      expect(issues, isEmpty);
    });
  });
}
