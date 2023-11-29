import 'package:amt/hiveAdapters/armour_adapter.dart';
import 'package:amt/hiveAdapters/armour_data_adapter.dart';
import 'package:amt/hiveAdapters/character_ki_adapter.dart';
import 'package:amt/hiveAdapters/combat_data_adapter.dart';
import 'package:amt/hiveAdapters/consumable_state_adapter.dart';
import 'package:amt/hiveAdapters/modifier_state_adapter.dart';
import 'package:amt/hiveAdapters/mystical_adapter.dart';
import 'package:amt/hiveAdapters/psychic_data_adapter.dart';
import 'package:amt/hiveAdapters/status_modifier_adapter.dart';
import 'package:amt/hiveAdapters/weapon_adapter.dart';
import 'package:amt/models/enums.dart';
import 'package:amt/hiveAdapters/attributes_list_adapter.dart';
import 'package:amt/hiveAdapters/character_adapter.dart';
import 'package:amt/hiveAdapters/character_profile_adapter.dart';
import 'package:amt/hiveAdapters/character_state_adapter.dart';
import 'package:amt/hiveAdapters/roll_adapter.dart';
import 'package:amt/presentation/charactersTable/characters_table.dart';
import 'package:amt/presentation/combat/combat_attack_card.dart';
import 'package:amt/presentation/combat/combat_defense_card.dart';
import 'package:amt/presentation/combat/custom_combat_card.dart';
import 'package:amt/presentation/states/characters_page_state.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return ChangeNotifierProvider(
      create: (context) => CharactersPageState(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Personajes',
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
    var appState = context.watch<CharactersPageState>();
    var theme = Theme.of(context);
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height - 50;
    var isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text("Personajes"),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () {
              appState.getCharacters();
            },
          ),
          IconButton(
            icon: Icon(Icons.repeat),
            onPressed: () {
              appState.rollTurns();
            },
          )
        ],
      ),
      body: ColoredBox(
        color: theme.colorScheme.background,
        child: Align(
          alignment: Alignment.topLeft,
          child: Flex(
            direction: isLandscape ? Axis.horizontal : Axis.vertical,
            children: [
              SizedBox(
                height: isLandscape ? height : height / 3,
                width: isLandscape ? screenSize.width / 1.5 : screenSize.width,
                child: CharactersTable(),
              ),
              SizedBox(
                height: isLandscape ? height : height / 1.5, // 3
                width: isLandscape ? screenSize.width / 3 : screenSize.width,
                child: CombatSection(
                  isLandscape: true,
                ),
              ),
            ],
          ),
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
    final theme = Theme.of(context);
    var appState = context.watch<CharactersPageState>();

    return ColoredBox(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CombatAttackCard(),
            CombatDefenseCard(),
            // Total
            CustomCombatCard(
              title: "Resultado",
              children: [
                Text(
                  appState.combatState.combatTotal(),
                ),
                TextButton(
                  onPressed: () {
                    var character = appState
                        .characters[appState.combatState.defendantCharacter];

                    character.removeFrom(
                      appState.combatState.calculateDamage(),
                      ConsumableType.hitPoints,
                    );

                    appState.updateCharacter(character);
                  },
                  child: Text("Aplicar daño"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
