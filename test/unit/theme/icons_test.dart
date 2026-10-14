import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levelup/theme/icons.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppIcons', () {
    test('every key maps to an asset declared in the bundle', () async {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final declared = manifest.listAssets().toSet();

      for (final key in AppIcons.keys) {
        expect(
          declared,
          contains(AppIcons.assetFor(key)),
          reason: 'icon "$key" has no declared asset',
        );
      }
    });

    test('every SVG file in assets/icons is reachable from a key', () {
      final mapped = AppIcons.keys.map(AppIcons.assetFor).toSet();
      final onDisk = Directory('assets/icons')
          .listSync()
          .whereType<File>()
          .map((f) => 'assets/icons/${f.uri.pathSegments.last}')
          .toSet();

      expect(onDisk, mapped);
    });

    test('default habit icon is target', () {
      expect(AppIcons.defaultHabit, 'target');
      expect(AppIcons.keys, contains(AppIcons.defaultHabit));
    });

    test('covers picker, interface and medal-track icons', () {
      expect(
        AppIcons.keys,
        containsAll(<String>[
          'gym',
          'book',
          'code',
          'yoga',
          'run',
          'candy',
          'water',
          'leaf',
          'sleep',
          'pencil',
          'paint',
          'wallet',
          'phone',
          'target',
          'star',
          'crown',
          'rocket',
          'lock',
          'list',
          'moon',
          'trophy',
          'medal',
          'close',
          'back',
          'add',
          'cog',
          'chevron-down',
          'check',
          'gem',
          'flame',
          'flash',
          'gift',
        ]),
      );
    });

    test('unknown key falls back to the default asset instead of throwing', () {
      expect(
        AppIcons.assetFor('does-not-exist'),
        AppIcons.assetFor(AppIcons.defaultHabit),
      );
      expect(AppIcons.assetFor(''), AppIcons.assetFor(AppIcons.defaultHabit));
    });

    test('isKnown tells known from unknown keys', () {
      expect(AppIcons.isKnown('flame'), isTrue);
      expect(AppIcons.isKnown('nope'), isFalse);
    });
  });
}
