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
import 'package:amt/presentation/states/non_player_caracters_state.dart';
import 'package:amt/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ArmourAdapter());
  Hive.registerAdapter(ArmourDataAdapter());
  Hive.registerAdapter(AttributesListAdapter());
  Hive.registerAdapter(CharacterAdapter());
  Hive.registerAdapter(CharacterKiAdapter());
  Hive.registerAdapter(CharacterProfileAdapter());
  Hive.registerAdapter(CharacterStateAdapter());
  Hive.registerAdapter(CombatDataAdapter());
  Hive.registerAdapter(ConsumableStateAdapter());
  Hive.registerAdapter(ModifiersStateAdapter());
  Hive.registerAdapter(MysticalAdapter());
  Hive.registerAdapter(PsychicDataAdapter());
  Hive.registerAdapter(RollAdapter());
  Hive.registerAdapter(StatusModifierAdapter());
  Hive.registerAdapter(WeaponAdapter());

  Hive.registerAdapter(DefenseTypeAdapter());
  Hive.registerAdapter(DamageTypesAdapter());
  Hive.registerAdapter(WeaponSizeAdapter());
  Hive.registerAdapter(KnownTypeAdapter());
  Hive.registerAdapter(ArmourLocationAdapter());
  Hive.registerAdapter(ConsumableTypeAdapter());
  Hive.registerAdapter(CharacterResistancesAdapter());

  print("registered adapters");

  runApp(MyApp());
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
        ChangeNotifierProvider(create: (context) => NonPlayerCharactersState())
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Anima Master Toolkit v3',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GeneratorPage();
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var screenSize = MediaQuery.of(context).size;
    var small = screenSize.width < 1120;
    var appState = context.watch<CharactersPageState>();
    var nonCharactersState = context.watch<NonPlayerCharactersState>();
    final Uri repository = Uri.parse('https://github.com/aoalejo/animaMasterToolkit');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text("Anima Master Toolkit v3"),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            onPressed: () {
              launchUrl(repository, webOnlyWindowName: "_blank");
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
                onRemoveAll: () => appState.removeAllNPC(),
                onAddNpc: () => nonCharactersState.getCharacters(),
                onRemove: (character) => nonCharactersState.removeNPC(character),
              );
            },
            icon: Icon(Icons.group),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _content(theme, screenSize, small, appState.pageSelected)),
          small
              ? BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.list), label: "Listado"),
                    BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Detalle"),
                    BottomNavigationBarItem(icon: Icon(Icons.bolt), label: "Combate"),
                  ],
                  onTap: (index) {
                    appState.updatePageSelected(index);
                  },
                  currentIndex: appState.pageSelected,
                )
              : Container()
        ],
      ),
    );
  }

  Widget _content(ThemeData theme, Size screenSize, bool small, int pageSelected) {
    return ColoredBox(
      color: theme.colorScheme.background,
      child: Align(
        alignment: Alignment.topLeft,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            pageSelected == 0 || !small
                ? SizedBox(
                    height: screenSize.height,
                    width: small ? screenSize.width : screenSize.width / 3,
                    child: CharactersTable(),
                  )
                : Container(),
            pageSelected == 1 || !small
                ? Column(
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
                : Container(),
            pageSelected == 2 || !small
                ? SizedBox(
                    height: screenSize.height,
                    width: small ? screenSize.width : screenSize.width / 3,
                    child: CombatSection(
                      isLandscape: true,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class CombatSection extends StatelessWidget {
  final bool isLandscape;
  CombatSection({required this.isLandscape});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
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
