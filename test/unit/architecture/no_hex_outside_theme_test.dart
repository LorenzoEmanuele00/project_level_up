import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Colour literals are only allowed inside `lib/theme/`. Everything else must
/// read tokens through `context.lu.*`. `Colors.transparent` is the one
/// exception: it carries no design decision.
final _forbidden = RegExp(
  r'\bColor\(\s*(0x[0-9a-fA-F]+|\d+)'
  r'|\bColor\.(fromARGB|fromRGBO|from)\b'
  r'|\b0x[0-9a-fA-F]{8}\b'
  r'|#[0-9a-fA-F]{6,8}\b'
  r'|\b(Cupertino)?Colors\.(?!transparent\b)'
  r'|\bHSLColor\b',
);

List<String> findColorLiterals(String source) =>
    _forbidden.allMatches(source).map((match) => match.group(0) ?? '').toList();

void main() {
  group('findColorLiterals', () {
    test('detects hex and decimal Color constructors', () {
      expect(findColorLiterals('final c = Color(0xFFD9614C);'), isNotEmpty);
      expect(findColorLiterals('final c = Color(4294967295);'), isNotEmpty);
    });

    test('detects the named Color constructors', () {
      expect(findColorLiterals('Color.fromARGB(255, 1, 2, 3)'), isNotEmpty);
      expect(findColorLiterals('Color.fromRGBO(1, 2, 3, .5)'), isNotEmpty);
      expect(findColorLiterals('Color.from(alpha: 1, red: 0)'), isNotEmpty);
    });

    test('detects bare ARGB integers and CSS style hex', () {
      expect(findColorLiterals('const x = 0xFFD9614C;'), isNotEmpty);
      expect(findColorLiterals('// #d9614c'), isNotEmpty);
      expect(findColorLiterals('// #aabbccdd'), isNotEmpty);
    });

    test('detects the Colors palettes and HSLColor', () {
      expect(findColorLiterals('color: Colors.red'), isNotEmpty);
      expect(findColorLiterals('color: CupertinoColors.white'), isNotEmpty);
      expect(findColorLiterals('HSLColor.fromAHSL(1, 0, 0, 0)'), isNotEmpty);
    });

    test('accepts Colors.transparent and token access', () {
      expect(findColorLiterals('color: Colors.transparent'), isEmpty);
      expect(findColorLiterals('color: context.lu.surface'), isEmpty);
    });

    test('reports the offending literal', () {
      expect(findColorLiterals('Color(0xFF123456)'), ['Color(0xFF123456']);
    });
  });

  group('colour literals', () {
    test('appear only under lib/theme/', () {
      final libDir = Directory('lib');
      expect(libDir.existsSync(), isTrue, reason: 'run from the package root');

      final offenders = <String>[];
      for (final entity in libDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final path = entity.path.replaceAll(r'\', '/');
        if (path.startsWith('lib/theme/')) continue;
        final matches = findColorLiterals(entity.readAsStringSync());
        if (matches.isNotEmpty) offenders.add('$path: ${matches.join(', ')}');
      }

      expect(offenders, isEmpty, reason: 'use context.lu.* instead of hex');
    });
  });
}
