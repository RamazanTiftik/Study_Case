import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('de'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @title.
  ///
  /// In de, this message translates to:
  /// **'Willkommen'**
  String get title;

  /// No description provided for @filter.
  ///
  /// In de, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @apply.
  ///
  /// In de, this message translates to:
  /// **'Anwenden'**
  String get apply;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @startDate.
  ///
  /// In de, this message translates to:
  /// **'Anfangsdatum'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In de, this message translates to:
  /// **'Enddatum'**
  String get endDate;

  /// No description provided for @loginFailed.
  ///
  /// In de, this message translates to:
  /// **'Anmeldung fehlgeschlagen!'**
  String get loginFailed;

  /// No description provided for @resetPasswordLinkSent.
  ///
  /// In de, this message translates to:
  /// **'Link zum Zurücksetzen des Passworts wurde an Ihre E-Mail gesendet.'**
  String get resetPasswordLinkSent;

  /// No description provided for @error.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get error;

  /// No description provided for @googleSignInFailed.
  ///
  /// In de, this message translates to:
  /// **'Google-Anmeldung fehlgeschlagen'**
  String get googleSignInFailed;

  /// No description provided for @resetPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort zurücksetzen'**
  String get resetPassword;

  /// No description provided for @enterEmailToReset.
  ///
  /// In de, this message translates to:
  /// **'Geben Sie Ihre E-Mail-Adresse ein, der Link zum Zurücksetzen wird gesendet.'**
  String get enterEmailToReset;

  /// No description provided for @emailHint.
  ///
  /// In de, this message translates to:
  /// **'Ihre E-Mail-Adresse'**
  String get emailHint;

  /// No description provided for @enterEmailAlert.
  ///
  /// In de, this message translates to:
  /// **'Bitte geben Sie eine E-Mail ein!'**
  String get enterEmailAlert;

  /// No description provided for @send.
  ///
  /// In de, this message translates to:
  /// **'Senden'**
  String get send;

  /// No description provided for @passwordHint.
  ///
  /// In de, this message translates to:
  /// **'Bitte geben Sie Ihr Passwort ein!'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort vergessen?'**
  String get forgotPassword;

  /// No description provided for @loggingIn.
  ///
  /// In de, this message translates to:
  /// **'Anmeldung läuft...'**
  String get loggingIn;

  /// No description provided for @login.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get login;

  /// No description provided for @noAccountYet.
  ///
  /// In de, this message translates to:
  /// **'Noch kein Konto?'**
  String get noAccountYet;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In de, this message translates to:
  /// **'Passwörter stimmen nicht überein!'**
  String get passwordsDoNotMatch;

  /// No description provided for @signUpFailed.
  ///
  /// In de, this message translates to:
  /// **'Registrierung fehlgeschlagen!'**
  String get signUpFailed;

  /// No description provided for @signUp.
  ///
  /// In de, this message translates to:
  /// **'Registrieren'**
  String get signUp;

  /// No description provided for @signingUp.
  ///
  /// In de, this message translates to:
  /// **'Registrierung läuft...'**
  String get signingUp;

  /// No description provided for @usernameHint.
  ///
  /// In de, this message translates to:
  /// **'Benutzername'**
  String get usernameHint;

  /// No description provided for @email.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort bestätigen'**
  String get confirmPassword;

  /// No description provided for @homeScreenTitle.
  ///
  /// In de, this message translates to:
  /// **'Startseite'**
  String get homeScreenTitle;

  /// No description provided for @selectCountry.
  ///
  /// In de, this message translates to:
  /// **'Land auswählen'**
  String get selectCountry;

  /// No description provided for @selectCategory.
  ///
  /// In de, this message translates to:
  /// **'Kategorie auswählen'**
  String get selectCategory;

  /// No description provided for @myFavorites.
  ///
  /// In de, this message translates to:
  /// **'Meine Favoriten'**
  String get myFavorites;

  /// No description provided for @noFavoriteTrips.
  ///
  /// In de, this message translates to:
  /// **'Sie haben keine Favoritenreisen'**
  String get noFavoriteTrips;

  /// No description provided for @profileScreen.
  ///
  /// In de, this message translates to:
  /// **'Profilseite'**
  String get profileScreen;

  /// No description provided for @fullName.
  ///
  /// In de, this message translates to:
  /// **'Vollständiger Name'**
  String get fullName;

  /// No description provided for @createdAt.
  ///
  /// In de, this message translates to:
  /// **'Erstellt am'**
  String get createdAt;

  /// No description provided for @lastLogin.
  ///
  /// In de, this message translates to:
  /// **'Letzte Anmeldung'**
  String get lastLogin;

  /// No description provided for @none.
  ///
  /// In de, this message translates to:
  /// **'Keine'**
  String get none;

  /// No description provided for @logout.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get logout;

  /// No description provided for @warning.
  ///
  /// In de, this message translates to:
  /// **'Warnung'**
  String get warning;

  /// No description provided for @confirmLogout.
  ///
  /// In de, this message translates to:
  /// **'Möchten Sie sich abmelden?'**
  String get confirmLogout;

  /// No description provided for @yes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In de, this message translates to:
  /// **'Nein'**
  String get no;
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
      <String>['de', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
