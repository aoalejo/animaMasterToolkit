import 'dart:async';
import 'dart:convert';
import 'dart:html' as web;
import 'dart:math';

import 'package:amt/firebase_options.dart';
import 'package:amt/generated/l10n.dart';
import 'package:amt/models/models.dart';
import 'package:amt/presentation/components/amt_text.dart';
import 'package:amt/presentation/login/login_screen.dart';
import 'package:amt/presentation/presentation.dart';
import 'package:amt/utils/assets.dart';
import 'package:amt/utils/cloud_firestore_sync.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
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
        title: 'Anima Master Toolkit v3',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'NotoSans',
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

  Future<void> saveState() async {
    final appState = Provider.of<CharactersPageState>(context, listen: false);
    final snapshot = appState.getJsonSnapshot();

    appState.showLoading(message: S.of(context).savingWithBody);
    final index = appState.campaignIndex;
    await database.saveSnapshot(snapshot, index.toString());
    appState.hideLoading();
  }

  Future<void> loadState() async {
    final appState = Provider.of<CharactersPageState>(context, listen: false);
    appState.showLoading(message: S.of(context).loadingWithBody);

    await database.obtainSnapshots();
    final index = appState.campaignIndex;

    final snapshot = await database.getSnapshot(index.toString());

    if (snapshot != null) {
      appState.loadJsonSnapshot(snapshot);
    } else {
      appState.loadJsonSnapshot(<String, dynamic>{'characters': <Map<String, dynamic>>[]});
    }

    appState.hideLoading();
  }

  Future<void> changeCampaign(int id) async {
    final appState = Provider.of<CharactersPageState>(context, listen: false);
    await saveState();
    appState.changeCampaign(id);
    await loadState();
  }

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      web.window.onBeforeUnload.listen((e) async {
        final appState = Provider.of<CharactersPageState>(context, listen: false);
        if (user != null && !database.snapshotIsUploaded(appState.getJsonSnapshot())) {
          (e as web.BeforeUnloadEvent).returnValue = S.of(context).unsavedChanges;
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
                    title: user == null ? AmtText(S.of(context).logIn) : AmtText(S.of(context).logOut),
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
                      title: AmtText(S.of(context).saveState),
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
                      title: AmtText(S.of(context).loadState),
                      leading: const Icon(
                        Icons.cloud_download,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await loadState();
                      },
                    ),
                  Divider(),
                  ListTile(
                    title: AmtText(S.of(context).seeSourceCode),
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
                    title: AmtText(S.of(context).convertExcelToJson),
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
                    title: AmtText(S.of(context).addNPC),
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
                  if (user != null) Divider(),
                  if (user != null)
                    ListTile(
                      title: AmtText(
                        database.getCampaignName('1'),
                        style: AmtTextStyles.subtitle,
                      ),
                      subtitle: AmtText(
                        S.of(context).saveSlotNumber + '1',
                      ),
                      leading: const Icon(
                        Icons.groups,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        Navigator.pop(context);

                        changeCampaign(1);
                      },
                    ),
                  if (user != null)
                    ListTile(
                      title: AmtText(
                        database.getCampaignName('2'),
                        style: AmtTextStyles.subtitle,
                      ),
                      subtitle: AmtText(
                        S.of(context).saveSlotNumber + '2',
                      ),
                      leading: const Icon(
                        Icons.groups,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        Navigator.pop(context);

                        changeCampaign(2);
                      },
                    ),
                  Divider(),
                  ListTile(
                    title: AmtText(
                      S.of(context).import,
                    ),
                    leading: const Icon(
                      Icons.upload,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      Navigator.pop(context);

                      await showDialog<void>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: AmtText(
                                S.of(context).warning,
                                style: AmtTextStyles.title,
                              ),
                              content: AmtText(
                                S.of(context).replacesCurrentCampaign,
                                style: AmtTextStyles.subtitle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: AmtText(S.of(context).close),
                                ),
                                TextButton(
                                  onPressed: () {
                                    FilePicker.platform.pickFiles(allowMultiple: false).then((value) {
                                      if (value != null) {
                                        final file = value.files.single;
                                        final reader = web.FileReader();
                                        final blob = web.Blob([file.bytes!]);
                                        reader.readAsText(blob);
                                        reader.onLoadEnd.listen((event) {
                                          final json = reader.result as String;
                                          appState.loadJsonSnapshot(jsonDecode(json) as Map<String, dynamic>);
                                        });
                                      }
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: AmtText(S.of(context).import),
                                  style: TextButton.styleFrom(
                                    foregroundColor: theme.colorScheme.primary,
                                    backgroundColor: theme.colorScheme.primaryContainer,
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  ListTile(
                    title: AmtText(
                      S.of(context).export,
                    ),
                    leading: const Icon(
                      Icons.download,
                      color: Colors.black,
                    ),
                    onTap: () async {
                      final name = appState.campaignName ?? 'anima_master_toolkit';
                      final date = DateTime.now().dateTimeReadable().replaceAll('/', '-').replaceAll(':', ' ');

                      var snapshot = JsonEncoder.withIndent('  ').convert(appState.getJsonSnapshot());

                      await FileSaver.instance.saveFile(
                        bytes: Uint8List.fromList(snapshot.toString().codeUnits),
                        name: '$name $date.json',
                        customMimeType: 'application/json',
                      );

                      Navigator.pop(context);
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
                      child: AmtText('${(appState.sheetsLoadingPercentage * 100).toInt()}', style: AmtTextStyles.title),
                    ),
                  ],
                ),
              ),
            if (appState.sheetsLoadingPercentage != -1) const SizedBox.square(dimension: 8),
            if (appState.sheetsLoadingPercentage != -1) AmtText(S.of(context).loadingSheets),
            if (appState.sheetsLoadingPercentage == -1 && user != null)
              AmtText(
                appState.campaignName ?? S.of(context).nameOfTheCampaign,
                style: AmtTextStyles.title,
              ),
            if (appState.sheetsLoadingPercentage == -1 && user != null)
              IconButton(
                  onPressed: () {
                    final name = appState.campaignName;

                    showDialog(
                      context: context,
                      builder: (context) {
                        final controller = TextEditingController(text: name);
                        return AlertDialog(
                          title: AmtText(S.of(context).changeCampaignNameTitle, style: AmtTextStyles.title),
                          content: TextField(
                            controller: controller,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: AmtText(S.of(context).close),
                            ),
                            TextButton(
                              onPressed: () {
                                appState.changeCampaignName(controller.text);
                                saveState();

                                Navigator.pop(context);
                              },
                              child: AmtText(S.of(context).save),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.edit)),
            if (user == null)
              AmtText(
                S.of(context).title,
                style: AmtTextStyles.title,
              ),
            const Spacer(),
            // Show time of last save is available:
            if (database.lastUpdatedTime != null)
              AmtText(
                S.of(context).lastSave + '\n${database.lastUpdatedTime!.dateTimeReadable()}',
                textAlign: TextAlign.center,
              ),
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
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.list), label: S.of(context).list),
                    BottomNavigationBarItem(icon: Icon(Icons.receipt), label: S.of(context).detail),
                    BottomNavigationBarItem(icon: Icon(Icons.bolt), label: S.of(context).combat),
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
                          AmtText(S.of(context).welcomeTitle, textAlign: TextAlign.center, style: AmtTextStyles.title),
                          SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  AmtText(
                                    S.of(context).welcomeSubtitle,
                                    textAlign: TextAlign.center,
                                    style: AmtTextStyles.emphasis,
                                  ),
                                  SizedBox(height: 16),
                                  AmtText(
                                    S.of(context).welcomeBody,
                                    textAlign: TextAlign.center,
                                    style: AmtTextStyles.body,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: theme.colorScheme.primary,
                                    backgroundColor: theme.colorScheme.primaryContainer,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showWelcomeMessage = false;
                                    });
                                    LoginScreen.showLoginBottomSheet(context);
                                  },
                                  child: AmtText(S.of(context).signIn),
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
                                  child: AmtText(S.of(context).close),
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
            Row(
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
                              AmtText(
                                message?.split('#').first ?? '',
                                textAlign: TextAlign.center,
                                style: AmtTextStyles.title,
                              ),
                              AmtText(
                                message?.split('#').last ?? '',
                                textAlign: TextAlign.center,
                                style: AmtTextStyles.subtitle,
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

extension on DateTime {
  String dateTimeReadable() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/${year.toString().padLeft(4, '0')} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
