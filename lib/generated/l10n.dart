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

  /// `Guardar estado`
  String get saveState {
    return Intl.message(
      'Guardar estado',
      name: 'saveState',
      desc: '',
      args: [],
    );
  }

  /// `Cargar estado`
  String get loadState {
    return Intl.message(
      'Cargar estado',
      name: 'loadState',
      desc: '',
      args: [],
    );
  }

  /// `Ver el código fuente`
  String get seeSourceCode {
    return Intl.message(
      'Ver el código fuente',
      name: 'seeSourceCode',
      desc: '',
      args: [],
    );
  }

  /// `Conversor Excel a JSON`
  String get convertExcelToJson {
    return Intl.message(
      'Conversor Excel a JSON',
      name: 'convertExcelToJson',
      desc: '',
      args: [],
    );
  }

  /// `Añadir NPC`
  String get addNPC {
    return Intl.message(
      'Añadir NPC',
      name: 'addNPC',
      desc: '',
      args: [],
    );
  }

  /// `Cargando planillas...`
  String get loadingSheets {
    return Intl.message(
      'Cargando planillas...',
      name: 'loadingSheets',
      desc: '',
      args: [],
    );
  }

  /// `Anima Master Toolkit v3 - `
  String get appNameWithUser {
    return Intl.message(
      'Anima Master Toolkit v3 - ',
      name: 'appNameWithUser',
      desc: '',
      args: [],
    );
  }

  /// `Usuario Anonimo`
  String get anonymousUser {
    return Intl.message(
      'Usuario Anonimo',
      name: 'anonymousUser',
      desc: '',
      args: [],
    );
  }

  /// `Ultimo guardado: `
  String get lastSave {
    return Intl.message(
      'Ultimo guardado: ',
      name: 'lastSave',
      desc: '',
      args: [],
    );
  }

  /// `Listado`
  String get list {
    return Intl.message(
      'Listado',
      name: 'list',
      desc: '',
      args: [],
    );
  }

  /// `Detalle`
  String get detail {
    return Intl.message(
      'Detalle',
      name: 'detail',
      desc: '',
      args: [],
    );
  }

  /// `Combate`
  String get combat {
    return Intl.message(
      'Combate',
      name: 'combat',
      desc: '',
      args: [],
    );
  }

  /// `¡Bienvenido a Anima Master Toolkit!`
  String get welcomeTitle {
    return Intl.message(
      '¡Bienvenido a Anima Master Toolkit!',
      name: 'welcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `\nPara acceder a la funcionalidad de guardado de partidas, es necesario iniciar sesión en el sistema. Esto garantiza que tus datos estén seguros y disponibles en cualquier dispositivo que utilices.\n                                \nSi no deseas utilizar esta función, puedes acceder al sistema de forma anónima. Sin embargo, debes tener en cuenta que no podrás guardar tus avances de manera persistente, ya que esta opción está disponible exclusivamente para los usuarios registrados.`
  String get welcomeSubtitle {
    return Intl.message(
      '\nPara acceder a la funcionalidad de guardado de partidas, es necesario iniciar sesión en el sistema. Esto garantiza que tus datos estén seguros y disponibles en cualquier dispositivo que utilices.\n                                \nSi no deseas utilizar esta función, puedes acceder al sistema de forma anónima. Sin embargo, debes tener en cuenta que no podrás guardar tus avances de manera persistente, ya que esta opción está disponible exclusivamente para los usuarios registrados.',
      name: 'welcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `\n*El sistema anteriormente soportaba el guardado de partidas de forma local. Sin embargo, se identificaron problemas de persistencia en esta modalidad, lo que generaba riesgos para la integridad de los datos almacenados.\n\nPara abordar esta situación, se implementó el guardado en la nube como solución principal. Este enfoque no solo resuelve los problemas previos, sino que también permite que los usuarios accedan a sus datos desde múltiples dispositivos de forma segura y confiable.\n\nEs importante señalar que el sistema de guardado local anterior no ha sido eliminado. Si esta funcionalidad te estaba funcionando correctamente, debería seguir haciéndolo. Sin embargo, se recomienda encarecidamente utilizar el guardado en la nube para garantizar la seguridad de tus partidas y minimizar riesgos de pérdida de datos.\n\n¿Qué debo hacer si el guardado local aún funciona bien para mí?\nPuedes seguir usándolo. Sin embargo, es recomendable hacer una copia de seguridad en la nube para evitar problemas futuros, ya que cambiaré en un futuro el sistema de guardado local actual para actualizarlo a uno nuevo\n\n¿Qué ocurre si no tengo conexión a internet?\nEl sistema debería permitirte usarlo de manera local y sincronizar tus datos en la nube cuando recuperes la conexión.\n\n¿Hay algún costo asociado al guardado en la nube?\nNo. El guardado en la nube es una funcionalidad gratuita para todos los usuarios registrados en el sistema. No se requiere ningún pago adicional para acceder a esta característica.\n`
  String get welcomeBody {
    return Intl.message(
      '\n*El sistema anteriormente soportaba el guardado de partidas de forma local. Sin embargo, se identificaron problemas de persistencia en esta modalidad, lo que generaba riesgos para la integridad de los datos almacenados.\n\nPara abordar esta situación, se implementó el guardado en la nube como solución principal. Este enfoque no solo resuelve los problemas previos, sino que también permite que los usuarios accedan a sus datos desde múltiples dispositivos de forma segura y confiable.\n\nEs importante señalar que el sistema de guardado local anterior no ha sido eliminado. Si esta funcionalidad te estaba funcionando correctamente, debería seguir haciéndolo. Sin embargo, se recomienda encarecidamente utilizar el guardado en la nube para garantizar la seguridad de tus partidas y minimizar riesgos de pérdida de datos.\n\n¿Qué debo hacer si el guardado local aún funciona bien para mí?\nPuedes seguir usándolo. Sin embargo, es recomendable hacer una copia de seguridad en la nube para evitar problemas futuros, ya que cambiaré en un futuro el sistema de guardado local actual para actualizarlo a uno nuevo\n\n¿Qué ocurre si no tengo conexión a internet?\nEl sistema debería permitirte usarlo de manera local y sincronizar tus datos en la nube cuando recuperes la conexión.\n\n¿Hay algún costo asociado al guardado en la nube?\nNo. El guardado en la nube es una funcionalidad gratuita para todos los usuarios registrados en el sistema. No se requiere ningún pago adicional para acceder a esta característica.\n',
      name: 'welcomeBody',
      desc: '',
      args: [],
    );
  }

  /// `Iniciar sesión`
  String get signIn {
    return Intl.message(
      'Iniciar sesión',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Cerrar`
  String get close {
    return Intl.message(
      'Cerrar',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Guardando...#Sincronizando partida en la nube`
  String get savingWithBody {
    return Intl.message(
      'Guardando...#Sincronizando partida en la nube',
      name: 'savingWithBody',
      desc: '',
      args: [],
    );
  }

  /// `Cargando...#Sincronizando partida en la nube`
  String get loadingWithBody {
    return Intl.message(
      'Cargando...#Sincronizando partida en la nube',
      name: 'loadingWithBody',
      desc: '',
      args: [],
    );
  }

  /// `Tienes cambios sin guardar`
  String get unsavedChanges {
    return Intl.message(
      'Tienes cambios sin guardar',
      name: 'unsavedChanges',
      desc: '',
      args: [],
    );
  }

  /// `Anima Master Toolkit v3`
  String get title {
    return Intl.message(
      'Anima Master Toolkit v3',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Guardar`
  String get save {
    return Intl.message(
      'Guardar',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Cambia el nombre a la campaña actual`
  String get changeCampaignNameTitle {
    return Intl.message(
      'Cambia el nombre a la campaña actual',
      name: 'changeCampaignNameTitle',
      desc: '',
      args: [],
    );
  }

  /// `¡Advertencia!`
  String get warning {
    return Intl.message(
      '¡Advertencia!',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Esto reemplazará la campaña actual`
  String get replacesCurrentCampaign {
    return Intl.message(
      'Esto reemplazará la campaña actual',
      name: 'replacesCurrentCampaign',
      desc: '',
      args: [],
    );
  }

  /// `Importar`
  String get import {
    return Intl.message(
      'Importar',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `Exportar`
  String get export {
    return Intl.message(
      'Exportar',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Slot de guardado `
  String get saveSlotNumber {
    return Intl.message(
      'Slot de guardado ',
      name: 'saveSlotNumber',
      desc: '',
      args: [],
    );
  }

  /// `Iniciar sesión`
  String get logIn {
    return Intl.message(
      'Iniciar sesión',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Cerrar sesión`
  String get logOut {
    return Intl.message(
      'Cerrar sesión',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Nombre de la campaña`
  String get nameOfTheCampaign {
    return Intl.message(
      'Nombre de la campaña',
      name: 'nameOfTheCampaign',
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
