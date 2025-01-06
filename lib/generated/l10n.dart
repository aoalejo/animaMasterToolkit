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

  /// `Modificar Armadura`
  String get modifyArmor {
    return Intl.message(
      'Modificar Armadura',
      name: 'modifyArmor',
      desc: '',
      args: [],
    );
  }

  /// `Nombre`
  String get name {
    return Intl.message(
      'Nombre',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Sin armadura`
  String get withoutArmour {
    return Intl.message(
      'Sin armadura',
      name: 'withoutArmour',
      desc: '',
      args: [],
    );
  }

  /// `Filo`
  String get damageFIL {
    return Intl.message(
      'Filo',
      name: 'damageFIL',
      desc: '',
      args: [],
    );
  }

  /// `Penetrante`
  String get damagePEN {
    return Intl.message(
      'Penetrante',
      name: 'damagePEN',
      desc: '',
      args: [],
    );
  }

  /// `Contundente`
  String get damageCON {
    return Intl.message(
      'Contundente',
      name: 'damageCON',
      desc: '',
      args: [],
    );
  }

  /// `Frio`
  String get damageFRI {
    return Intl.message(
      'Frio',
      name: 'damageFRI',
      desc: '',
      args: [],
    );
  }

  /// `Calor`
  String get damageCAL {
    return Intl.message(
      'Calor',
      name: 'damageCAL',
      desc: '',
      args: [],
    );
  }

  /// `Electricidad`
  String get damageELE {
    return Intl.message(
      'Electricidad',
      name: 'damageELE',
      desc: '',
      args: [],
    );
  }

  /// `Energía`
  String get damageENE {
    return Intl.message(
      'Energía',
      name: 'damageENE',
      desc: '',
      args: [],
    );
  }

  /// `Eliminar 1 TA a todo`
  String get removeTAtoAll {
    return Intl.message(
      'Eliminar 1 TA a todo',
      name: 'removeTAtoAll',
      desc: '',
      args: [],
    );
  }

  /// `Añadir 1 TA a todo`
  String get addTAtoAll {
    return Intl.message(
      'Añadir 1 TA a todo',
      name: 'addTAtoAll',
      desc: '',
      args: [],
    );
  }

  /// `Reemplazar por otra:`
  String get replaceForAnother {
    return Intl.message(
      'Reemplazar por otra:',
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
