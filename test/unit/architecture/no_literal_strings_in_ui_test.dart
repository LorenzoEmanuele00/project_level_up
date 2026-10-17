import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// User-visible strings must come from `context.l10n.*`, never from literals
/// in widgets. Detects a string literal containing a letter used as:
/// - the first positional argument of `Text`, `TextSpan`, `SelectableText`
/// - a `text:` argument
/// - a named argument that renders text (title, label, hintText, ...)
const _literal = r'''(?:'(?:[^'\\\n]|\\.)*'|"(?:[^"\\\n]|\\.)*")''';

final _textArguments = RegExp(
  '(?<![A-Za-z0-9_])(?:Text|TextSpan|SelectableText)\\(\\s*($_literal)'
  '|\\btext\\s*:\\s*($_literal)'
  '|\\b(?:title|label|labelText|hintText|helperText|errorText|tooltip'
  '|semanticLabel|semanticsLabel|message)\\s*:\\s*($_literal)',
);

final _interpolation = RegExp(r'\$\{[^}]*\}|\$\w+');
final _letter = RegExp(r'\p{L}', unicode: true);

bool _hasLetter(String literal) {
  final content = literal.substring(1, literal.length - 1);
  return _letter.hasMatch(content.replaceAll(_interpolation, ''));
}

List<String> findUiLiterals(String source) {
  final found = <String>[];
  for (final match in _textArguments.allMatches(source)) {
    final literal = match.group(1) ?? match.group(2) ?? match.group(3);
    if (literal != null && _hasLetter(literal)) found.add(literal);
  }
  return found;
}

void main() {
  group('findUiLiterals', () {
    test('detects a literal as first positional argument of Text widgets', () {
      expect(findUiLiterals("Text('Ciao')"), ["'Ciao'"]);
      expect(findUiLiterals('Text("Ciao", style: s)'), ['"Ciao"']);
      expect(findUiLiterals("SelectableText('Ciao')"), isNotEmpty);
      expect(findUiLiterals("TextSpan('Ciao')"), isNotEmpty);
      expect(findUiLiterals("Text(\n  'Ciao',\n)"), isNotEmpty);
    });

    test('detects text: and the named text arguments', () {
      expect(findUiLiterals("TextSpan(text: 'x')"), ["'x'"]);
      expect(findUiLiterals("AppBar(title: 'X')"), ["'X'"]);
      for (final name in [
        'label',
        'labelText',
        'hintText',
        'helperText',
        'errorText',
        'tooltip',
        'semanticLabel',
        'semanticsLabel',
        'message',
      ]) {
        expect(findUiLiterals("Foo($name: 'Salva')"), isNotEmpty, reason: name);
      }
    });

    test('detects non-ASCII letters', () {
      expect(findUiLiterals("Text('Già')"), isNotEmpty);
    });

    test('accepts localized strings and non-text arguments', () {
      expect(findUiLiterals('Text(context.l10n.appTitle)'), isEmpty);
      expect(findUiLiterals("AppIcon('gym', size: 24)"), isEmpty);
      expect(findUiLiterals('title: context.l10n.appTitle'), isEmpty);
      expect(findUiLiterals("AppText.display.copyWith(color: c)"), isEmpty);
    });

    test('accepts literals without letters', () {
      expect(findUiLiterals("Text('')"), isEmpty);
      expect(findUiLiterals("Text('\$n')"), isEmpty);
      expect(findUiLiterals("Text('\${a + b}')"), isEmpty);
      expect(findUiLiterals("Text('12 / 34')"), isEmpty);
    });

    test('does not match widgets that merely end in Text', () {
      expect(findUiLiterals("AppText('x')"), isEmpty);
    });
  });

  group('UI string literals', () {
    test('do not appear under lib/ui/ or lib/app/', () {
      final libDir = Directory('lib');
      expect(libDir.existsSync(), isTrue, reason: 'run from the package root');

      final offenders = <String>[];
      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final path = entity.path.replaceAll(r'\', '/');
        if (!path.startsWith('lib/ui/') && !path.startsWith('lib/app/')) {
          continue;
        }
        final matches = findUiLiterals(entity.readAsStringSync());
        if (matches.isNotEmpty) offenders.add('$path: ${matches.join(', ')}');
      }

      expect(offenders, isEmpty, reason: 'use context.l10n.* instead');
    });
  });
}
