import 'dart:async';
import 'dart:html' as web;
import 'dart:math';

import 'package:amt/firebase_options.dart';
import 'package:amt/generated/l10n.dart';
import 'package:amt/models/models.dart';
import 'package:amt/presentation/login/login_screen.dart';
import 'package:amt/presentation/presentation.dart';
import 'package:amt/utils/assets.dart';
import 'package:amt/utils/cloud_firestore_sync.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(ArmourAdapter())
    ..registerAdapter(ArmourDataAdapter())
    ..registerAdapter(AttributesListAdapter())
    ..registerAdapter(CharacterAdapter())
    ..registerAdapter(CharacterKiAdapter())
    ..registerAdapter(CharacterProfileAdapter())
    ..registerAdapter(CharacterStateAdapter())
    ..registerAdapter(CombatDataAdapter())
    ..registerAdapter(ConsumableStateAdapter())
    ..registerAdapter(ModifiersStateAdapter())
    ..registerAdapter(MysticalAdapter())
    ..registerAdapter(PsychicDataAdapter())
    ..registerAdapter(RollAdapter())
    ..registerAdapter(StatusModifierAdapter())
    ..registerAdapter(WeaponAdapter())
    ..registerAdapter(DefenseTypeAdapter())
    ..registerAdapter(DamageTypesAdapter())
    ..registerAdapter(WeaponSizeAdapter())
    ..registerAdapter(KnownTypeAdapter())
    ..registerAdapter(ArmourLocationAdapter())
    ..registerAdapter(ConsumableTypeAdapter())
    ..registerAdapter(CharacterResistancesAdapter());

  Logger().d('registered adapters');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CharactersPageState()),
        ChangeNotifierProvider(create: (context) => NonPlayerCharactersState()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FirebaseUILocalizations.withDefaultOverrides(const EsLocalizations()),
          S.delegate,
        ],
        title: 'Anima Master Toolkit v3 - Usuario Anonimo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  CloudSync database = CloudFirestoreSync();
  User? user;
  final repository = Uri.parse('https://github.com/aoalejo/animaMasterToolkit');
  final excelToJsonRelease = Uri.parse('https://github.com/aoalejo/animaExcelToJson/releases');
  bool showWelcomeMessage = false;

  @override
  void dispose() {
    // Optionally clean up if necessary
    web.window.onBeforeUnload.drain<void>();
    super.dispose();
  }

  Future<void> saveState() async {
    final appState = Provider.of<CharactersPageState>(context, listen: false);
    final snapshot = appState.getJsonSnapshot();

    appState.showLoading(message: 'Guardando...#Sincronizando partida en la nube');
    await database.saveSnapshot(snapshot, '1');
    appState.hideLoading();
  }

  Future<void> loadState() async {
    final appState = Provider.of<CharactersPageState>(context, listen: false);
    appState.showLoading(message: 'Cargando...#Sincronizando partida en la nube');

    final snapshot = await database.getSnapshot('1');

    if (snapshot != null) {
      appState.loadJsonSnapshot(snapshot);
    }

    appState.hideLoading();
  }

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      web.window.onBeforeUnload.listen((e) async {
        final appState = Provider.of<CharactersPageState>(context, listen: false);
        if (user != null && !database.snapshotIsUploaded(appState.getJsonSnapshot())) {
          (e as web.BeforeUnloadEvent).returnValue = 'Tienes cambios sin guardar';
        }
      });
    }

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });

      if (user != null) {
        loadState();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (user == null) {
        setState(() {
          showWelcomeMessage = true;
        });
      } else {
        await loadState();
      }
    });

    // Autosave every five minutes if no changes detected:
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      final appState = Provider.of<CharactersPageState>(context, listen: false);
      final snapshot = appState.getJsonSnapshot();
      if (database.snapshotNeedsToBeUploaded(snapshot)) {
        saveState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final small = screenSize.width < 1120;
    final nonCharactersState = context.watch<NonPlayerCharactersState>();
    final appState = context.watch<CharactersPageState>();

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: user == null ? const Text('Iniciar sesión') : const Text('Cerrar sesión'),
                    leading: const Icon(
                      Icons.login,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      if (user != null) {
                        await FirebaseAuth.instance.signOut();

                        return;
                      }

                      await LoginScreen.showLoginBottomSheet(context);
                    },
                  ),
                  if (user != null)
                    ListTile(
                      title: const Text('Guardar estado'),
                      leading: const Icon(
                        Icons.cloud_upload,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await saveState();
                      },
                    ),
                  if (user != null)
                    ListTile(
                      title: const Text('Cargar estado'),
                      leading: const Icon(
                        Icons.cloud_download,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await loadState();
                      },
                    ),
                  ListTile(
                    title: const Text('Ver el código fuente'),
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: Assets.github,
                    ),
                    onTap: () {
                      launchUrl(repository, webOnlyWindowName: '_blank');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Conversor Excel a JSON'),
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: Assets.excelConvert,
                    ),
                    onTap: () {
                      launchUrl(excelToJsonRelease, webOnlyWindowName: '_blank');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Añadir NPC'),
                    leading: const Icon(
                      Icons.group,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      NPCSelector.open(
                        context,
                        theme,
                        characters: nonCharactersState.characters,
                        onSelected: (npc) {
                          appState.addCharacter(npc, isNpc: true);
                        },
                        onRemoveAll: appState.removeAllNPC,
                        onAddNpc: nonCharactersState.getCharacters,
                        onRemove: nonCharactersState.removeNPC,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 50,
        title: Row(
          children: [
            if (appState.sheetsLoadingPercentage != -1)
              SizedBox.square(
                dimension: 24,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: appState.sheetsLoadingPercentage,
                      color: Colors.white,
                    ),
                    Center(
                      child: Text(
                        '${(appState.sheetsLoadingPercentage * 100).toInt()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (appState.sheetsLoadingPercentage != -1) const SizedBox.square(dimension: 8),
            if (appState.sheetsLoadingPercentage != -1) const Text('Cargando planillas...'),
            if (appState.sheetsLoadingPercentage == -1) Text('Anima Master Toolkit v3 - ${user?.displayName ?? user?.email ?? 'Usuario Anonimo'}'),
            const Spacer(),
            // Show time of last save is available:
            if (database.lastUpdatedTime != null) Text('Ultimo guardado: ${database.lastUpdatedTime!.hour}:${database.lastUpdatedTime!.minute}'),
          ],
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: const [],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: _content(theme, screenSize, small, appState.pageSelected, appState.isLoading, appState.message)),
              if (small)
                BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Listado'),
                    BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Detalle'),
                    BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Combate'),
                  ],
                  onTap: appState.updatePageSelected,
                  currentIndex: appState.pageSelected,
                )
              else
                Container(),
            ],
          ),
          if (showWelcomeMessage)
            Stack(
              children: [
                const SizedBox.expand(child: ColoredBox(color: Colors.black26)),
                Center(
                  child: SizedBox(
                    width: max(screenSize.width / 3, 300),
                    height: max(screenSize.width / 4, 300),
                    child: Container(
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)), color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          const Text(
                            '¡Bienvenido a Anima Master Toolkit!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const Text(
                                    '''
Para acceder a la funcionalidad de guardado de partidas, es necesario iniciar sesión en el sistema. Esto garantiza que tus datos estén seguros y disponibles en cualquier dispositivo que utilices.
                                
Si no deseas utilizar esta función, puedes acceder al sistema de forma anónima. Sin embargo, debes tener en cuenta que no podrás guardar tus avances de manera persistente, ya que esta opción está disponible exclusivamente para los usuarios registrados.''',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Text(
                                    '''
*El sistema anteriormente soportaba el guardado de partidas de forma local. Sin embargo, se identificaron problemas de persistencia en esta modalidad, lo que generaba riesgos para la integridad de los datos almacenados.

Para abordar esta situación, se implementó el guardado en la nube como solución principal. Este enfoque no solo resuelve los problemas previos, sino que también permite que los usuarios accedan a sus datos desde múltiples dispositivos de forma segura y confiable.

Es importante señalar que el sistema de guardado local anterior no ha sido eliminado. Si esta funcionalidad te estaba funcionando correctamente, debería seguir haciéndolo. Sin embargo, se recomienda encarecidamente utilizar el guardado en la nube para garantizar la seguridad de tus partidas y minimizar riesgos de pérdida de datos.

¿Qué debo hacer si el guardado local aún funciona bien para mí?
Puedes seguir usándolo. Sin embargo, es recomendable hacer una copia de seguridad en la nube para evitar problemas futuros.

¿Qué ocurre si no tengo conexión a internet?
El sistema debería permitirte usarlo de manera local y sincronizar tus datos en la nube cuando recuperes la conexión.

¿Hay algún costo asociado al guardado en la nube?
No. El guardado en la nube es una funcionalidad gratuita para todos los usuarios registrados en el sistema. No se requiere ningún pago adicional para acceder a esta característica.
''',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  isSemanticButton: true,
                                  onPressed: () {
                                    setState(() {
                                      showWelcomeMessage = false;
                                    });
                                    LoginScreen.showLoginBottomSheet(context);
                                  },
                                  child: const Text('Iniciar sesión'),
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showWelcomeMessage = false;
                                    });
                                  },
                                  child: const Text('Cerrar'),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _content(ThemeData theme, Size screenSize, bool small, int pageSelected, bool loading, String? message) {
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Align(
        alignment: Alignment.topLeft,
        child: Stack(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                if (pageSelected == 0 || !small)
                  SizedBox(
                    height: screenSize.height,
                    width: small ? screenSize.width : screenSize.width / 3,
                    child: const CharactersTable(),
                  )
                else
                  Container(),
                if (pageSelected == 1 || !small)
                  Column(
                    children: [
                      SizedBox(
                        height: small ? (screenSize.height / 2) - 54 : (screenSize.height / 2) - 25,
                        width: small ? screenSize.width : screenSize.width / 3,
                        child: CharacterInfoCard(attacking: true),
                      ),
                      SizedBox(
                        height: small ? (screenSize.height / 2) - 54 : (screenSize.height / 2) - 25,
                        width: small ? screenSize.width : screenSize.width / 3,
                        child: CharacterInfoCard(attacking: false),
                      ),
                    ],
                  )
                else
                  Container(),
                if (pageSelected == 2 || !small)
                  SizedBox(
                    height: screenSize.height,
                    width: small ? screenSize.width : screenSize.width / 3,
                    child: const CombatSection(
                      isLandscape: true,
                    ),
                  )
                else
                  Container(),
              ],
            ),
            if (loading)
              Stack(
                children: [
                  const SizedBox.expand(child: ColoredBox(color: Colors.black26)),
                  Center(
                    child: SizedBox(
                      width: max(screenSize.width / 3, 300),
                      height: max(screenSize.width / 4, 300),
                      child: Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)), color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const CircularProgressIndicator(),
                              Text(
                                message?.split('#').first ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                message?.split('#').last ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class CombatSection extends StatelessWidget {
  const CombatSection({required this.isLandscape, super.key});
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CombatAttackCard(),
            CombatDefenseCard(),
            CombatReturnCard(),
            CombatCriticalCard(),
          ],
        ),
      ),
    );
  }
}
