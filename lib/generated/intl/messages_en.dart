// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addNPC": MessageLookupByLibrary.simpleMessage("Añadir NPC"),
        "addTAtoAll": MessageLookupByLibrary.simpleMessage("Add 1 TA to all"),
        "anonymousUser":
            MessageLookupByLibrary.simpleMessage("Usuario Anonimo"),
        "appNameWithUser":
            MessageLookupByLibrary.simpleMessage("Anima Master Toolkit v3 - "),
        "changeCampaignNameTitle": MessageLookupByLibrary.simpleMessage(
            "Cambia el nombre a la campaña actual"),
        "close": MessageLookupByLibrary.simpleMessage("Cerrar"),
        "combat": MessageLookupByLibrary.simpleMessage("Combate"),
        "convertExcelToJson":
            MessageLookupByLibrary.simpleMessage("Conversor Excel a JSON"),
        "damageCAL": MessageLookupByLibrary.simpleMessage("Heat"),
        "damageCON": MessageLookupByLibrary.simpleMessage("Blunt"),
        "damageELE": MessageLookupByLibrary.simpleMessage("Electricity"),
        "damageENE": MessageLookupByLibrary.simpleMessage("Energy"),
        "damageFIL": MessageLookupByLibrary.simpleMessage("Cutting"),
        "damageFRI": MessageLookupByLibrary.simpleMessage("Cold"),
        "damagePEN": MessageLookupByLibrary.simpleMessage("Piercing"),
        "detail": MessageLookupByLibrary.simpleMessage("Detalle"),
        "lastSave": MessageLookupByLibrary.simpleMessage("Ultimo guardado: "),
        "list": MessageLookupByLibrary.simpleMessage("Listado"),
        "loadState": MessageLookupByLibrary.simpleMessage("Cargar estado"),
        "loadingSheets":
            MessageLookupByLibrary.simpleMessage("Cargando planillas..."),
        "loadingWithBody": MessageLookupByLibrary.simpleMessage(
            "Cargando...#Sincronizando partida en la nube"),
        "modifyArmor": MessageLookupByLibrary.simpleMessage("Modify Armour"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "removeTAtoAll":
            MessageLookupByLibrary.simpleMessage("Remove 1 TA to all"),
        "replaceForAnother":
            MessageLookupByLibrary.simpleMessage("Replace for another:"),
        "save": MessageLookupByLibrary.simpleMessage("Guardar"),
        "saveState": MessageLookupByLibrary.simpleMessage("Guardar estado"),
        "savingWithBody": MessageLookupByLibrary.simpleMessage(
            "Guardando...#Sincronizando partida en la nube"),
        "seeSourceCode":
            MessageLookupByLibrary.simpleMessage("Ver el código fuente"),
        "signIn": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "title":
            MessageLookupByLibrary.simpleMessage("Anima Master Toolkit v3"),
        "unsavedChanges":
            MessageLookupByLibrary.simpleMessage("Tienes cambios sin guardar"),
        "welcomeBody": MessageLookupByLibrary.simpleMessage(
            "\n*El sistema anteriormente soportaba el guardado de partidas de forma local. Sin embargo, se identificaron problemas de persistencia en esta modalidad, lo que generaba riesgos para la integridad de los datos almacenados.\n\nPara abordar esta situación, se implementó el guardado en la nube como solución principal. Este enfoque no solo resuelve los problemas previos, sino que también permite que los usuarios accedan a sus datos desde múltiples dispositivos de forma segura y confiable.\n\nEs importante señalar que el sistema de guardado local anterior no ha sido eliminado. Si esta funcionalidad te estaba funcionando correctamente, debería seguir haciéndolo. Sin embargo, se recomienda encarecidamente utilizar el guardado en la nube para garantizar la seguridad de tus partidas y minimizar riesgos de pérdida de datos.\n\n¿Qué debo hacer si el guardado local aún funciona bien para mí?\nPuedes seguir usándolo. Sin embargo, es recomendable hacer una copia de seguridad en la nube para evitar problemas futuros, ya que cambiaré en un futuro el sistema de guardado local actual para actualizarlo a uno nuevo\n\n¿Qué ocurre si no tengo conexión a internet?\nEl sistema debería permitirte usarlo de manera local y sincronizar tus datos en la nube cuando recuperes la conexión.\n\n¿Hay algún costo asociado al guardado en la nube?\nNo. El guardado en la nube es una funcionalidad gratuita para todos los usuarios registrados en el sistema. No se requiere ningún pago adicional para acceder a esta característica.\n"),
        "welcomeSubtitle": MessageLookupByLibrary.simpleMessage(
            "\nPara acceder a la funcionalidad de guardado de partidas, es necesario iniciar sesión en el sistema. Esto garantiza que tus datos estén seguros y disponibles en cualquier dispositivo que utilices.\n                                \nSi no deseas utilizar esta función, puedes acceder al sistema de forma anónima. Sin embargo, debes tener en cuenta que no podrás guardar tus avances de manera persistente, ya que esta opción está disponible exclusivamente para los usuarios registrados."),
        "welcomeTitle": MessageLookupByLibrary.simpleMessage(
            "¡Bienvenido a Anima Master Toolkit!"),
        "withoutArmour": MessageLookupByLibrary.simpleMessage("Without armour")
      };
}
