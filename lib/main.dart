import 'dart:math';

import 'package:amt/models/armour.dart';
import 'package:amt/models/armour_data.dart';
import 'package:amt/models/attributes_list.dart';
import 'package:amt/models/character/character.dart';
import 'package:amt/models/character/character_ki.dart';
import 'package:amt/models/character/character_resistances.dart';
import 'package:amt/models/character/character_state.dart';
import 'package:amt/models/character/consumable_state.dart';
import 'package:amt/models/character/status_modifier.dart';
import 'package:amt/models/character_profile.dart';
import 'package:amt/models/combat_data.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/models/modifiers_state.dart';
import 'package:amt/models/mystical.dart';
import 'package:amt/models/psychic_data.dart';
import 'package:amt/models/roll.dart';
import 'package:amt/models/weapon.dart';
import 'package:amt/presentation/charactersInfo/character_info_card.dart';
import 'package:amt/presentation/charactersTable/characters_table.dart';
import 'package:amt/presentation/combat/combat_attack_card.dart';
import 'package:amt/presentation/combat/combat_critical_card.dart';
import 'package:amt/presentation/combat/combat_defense_card.dart';
import 'package:amt/presentation/combat/combat_result_card.dart';
import 'package:amt/presentation/npcSelection/npc_selector_view.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:amt/presentation/states/non_player_characters_state.dart';
import 'package:amt/utils/assets.dart';
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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        title: 'Anima Master Toolkit v3',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GeneratorPage();
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final small = screenSize.width < 1120;
    final appState = context.watch<CharactersPageState>();
    final nonCharactersState = context.watch<NonPlayerCharactersState>();
    final repository = Uri.parse('https://github.com/aoalejo/animaMasterToolkit');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Row(
          children: [
            if (appState.sheetsLoadingPercentaje != -1)
              SizedBox.square(
                dimension: 24,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: appState.sheetsLoadingPercentaje,
                      color: Colors.white,
                    ),
                    Center(
                      child: Text(
                        '${(appState.sheetsLoadingPercentaje * 100).toInt()}',
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
            if (appState.sheetsLoadingPercentaje != -1) const SizedBox.square(dimension: 8),
            if (appState.sheetsLoadingPercentaje != -1) const Text('Cargando planillas...'),
            if (appState.sheetsLoadingPercentaje == -1) const Text('Anima Master Toolkit v3'),
          ],
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            onPressed: () {
              launchUrl(repository, webOnlyWindowName: '_blank');
            },
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Assets.github,
            ),
          ),
          IconButton(
            onPressed: () {
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
            icon: const Icon(Icons.group),
          ),
        ],
      ),
      body: Column(
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
    );
  }

  Widget _content(ThemeData theme, Size screenSize, bool small, int pageSelected, bool loading, String? message) {
    return ColoredBox(
      color: theme.colorScheme.background,
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
