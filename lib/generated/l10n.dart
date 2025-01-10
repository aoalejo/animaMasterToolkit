// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Modify Armour`
  String get modifyArmor {
    return Intl.message(
      'Modify Armour',
      name: 'modifyArmor',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Without armour`
  String get withoutArmour {
    return Intl.message(
      'Without armour',
      name: 'withoutArmour',
      desc: '',
      args: [],
    );
  }

  /// `Cutting`
  String get damageFIL {
    return Intl.message(
      'Cutting',
      name: 'damageFIL',
      desc: '',
      args: [],
    );
  }

  /// `Piercing`
  String get damagePEN {
    return Intl.message(
      'Piercing',
      name: 'damagePEN',
      desc: '',
      args: [],
    );
  }

  /// `Blunt`
  String get damageCON {
    return Intl.message(
      'Blunt',
      name: 'damageCON',
      desc: '',
      args: [],
    );
  }

  /// `Cold`
  String get damageFRI {
    return Intl.message(
      'Cold',
      name: 'damageFRI',
      desc: '',
      args: [],
    );
  }

  /// `Heat`
  String get damageCAL {
    return Intl.message(
      'Heat',
      name: 'damageCAL',
      desc: '',
      args: [],
    );
  }

  /// `Electricity`
  String get damageELE {
    return Intl.message(
      'Electricity',
      name: 'damageELE',
      desc: '',
      args: [],
    );
  }

  /// `Energy`
  String get damageENE {
    return Intl.message(
      'Energy',
      name: 'damageENE',
      desc: '',
      args: [],
    );
  }

  /// `Remove 1 TA to all`
  String get removeTAtoAll {
    return Intl.message(
      'Remove 1 TA to all',
      name: 'removeTAtoAll',
      desc: '',
      args: [],
    );
  }

  /// `Add 1 TA to all`
  String get addTAtoAll {
    return Intl.message(
      'Add 1 TA to all',
      name: 'addTAtoAll',
      desc: '',
      args: [],
    );
  }

  /// `Replace for another:`
  String get replaceForAnother {
    return Intl.message(
      'Replace for another:',
      name: 'replaceForAnother',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
