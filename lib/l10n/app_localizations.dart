import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// Nome dell'app, mostrato come titolo dell'applicazione e nella home.
  ///
  /// In it, this message translates to:
  /// **'LevelUp'**
  String get appTitle;

  /// Ricompensa in EXP mostrata sul tile di un'abitudine (es. "+20 EXP").
  ///
  /// In it, this message translates to:
  /// **'+{exp} EXP'**
  String habitExpGain(int exp);

  /// Etichetta di accessibilità del check di un'abitudine ancora da fare.
  ///
  /// In it, this message translates to:
  /// **'Completa {name}'**
  String habitCheckComplete(String name);

  /// Etichetta di accessibilità del check di un'abitudine già completata oggi.
  ///
  /// In it, this message translates to:
  /// **'{name} completata'**
  String habitCheckDone(String name);

  /// Saluto della Home dalle 05:00 alle 11:59.
  ///
  /// In it, this message translates to:
  /// **'Buongiorno, {name}'**
  String homeGreetingMorning(String name);

  /// Saluto della Home dalle 12:00 alle 17:59.
  ///
  /// In it, this message translates to:
  /// **'Buon pomeriggio, {name}'**
  String homeGreetingAfternoon(String name);

  /// Saluto della Home dalle 18:00 alle 04:59.
  ///
  /// In it, this message translates to:
  /// **'Buonasera, {name}'**
  String homeGreetingEvening(String name);

  /// Nome mostrato nel saluto quando l'eroe non ha un nome.
  ///
  /// In it, this message translates to:
  /// **'Eroe'**
  String get heroFallbackName;

  /// Riga sotto la barra della missione di oggi.
  ///
  /// In it, this message translates to:
  /// **'{done}/{due} completate · +{exp} EXP rimasti'**
  String heroMissionProgress(int done, int due, int exp);

  /// Etichetta della statistica delle habit completate oggi (mostrata in maiuscolo).
  ///
  /// In it, this message translates to:
  /// **'Fatte'**
  String get statDone;

  /// Etichetta della statistica degli EXP guadagnati oggi.
  ///
  /// In it, this message translates to:
  /// **'EXP'**
  String get statExp;

  /// Etichetta della statistica della streak più lunga.
  ///
  /// In it, this message translates to:
  /// **'Streak'**
  String get statStreak;

  /// Etichetta della statistica del livello dell'eroe.
  ///
  /// In it, this message translates to:
  /// **'Livello'**
  String get statLevel;

  /// Titolo della sezione delle habit di oggi nella Home.
  ///
  /// In it, this message translates to:
  /// **'Oggi'**
  String get homeTodayTitle;

  /// Azione che apre la lista di tutte le habit.
  ///
  /// In it, this message translates to:
  /// **'Vedi tutte'**
  String get homeSeeAll;

  /// Messaggio quando non resta nulla da fare oggi o nessuna habit è dovuta.
  ///
  /// In it, this message translates to:
  /// **'Tutto fatto per oggi'**
  String get homeAllDone;

  /// Messaggio quando il caricamento dei dati della Home fallisce.
  ///
  /// In it, this message translates to:
  /// **'Impossibile caricare le habit'**
  String get homeLoadError;

  /// Etichetta di accessibilità dell'avatar nella Home.
  ///
  /// In it, this message translates to:
  /// **'Apri il profilo'**
  String get homeOpenProfile;

  /// Etichetta di accessibilità della pill dei punti nella Home.
  ///
  /// In it, this message translates to:
  /// **'Reward points: {points}. Apri il Reward Shop'**
  String homeOpenRewards(int points);

  /// Etichetta di accessibilità dell'area statistiche nella Home.
  ///
  /// In it, this message translates to:
  /// **'Apri la missione di oggi'**
  String get homeOpenMission;

  /// Titolo delle schermate segnaposto.
  ///
  /// In it, this message translates to:
  /// **'Prossimamente'**
  String get comingSoonTitle;

  /// Testo delle schermate segnaposto.
  ///
  /// In it, this message translates to:
  /// **'Questa sezione arriva presto.'**
  String get comingSoonBody;

  /// Etichetta di accessibilità del pulsante che chiude una schermata segnaposto.
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get comingSoonClose;

  /// Nome della schermata segnaposto del profilo.
  ///
  /// In it, this message translates to:
  /// **'Profilo'**
  String get comingSoonProfile;

  /// Nome della schermata segnaposto dei reward.
  ///
  /// In it, this message translates to:
  /// **'Reward Shop'**
  String get comingSoonRewards;

  /// Nome della schermata segnaposto della missione.
  ///
  /// In it, this message translates to:
  /// **'Missione di oggi'**
  String get comingSoonMission;

  /// Nome della schermata segnaposto della lista habit.
  ///
  /// In it, this message translates to:
  /// **'Tutte le habit'**
  String get comingSoonHabits;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
