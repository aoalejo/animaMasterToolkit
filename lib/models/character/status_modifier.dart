class StatusModifier {
  String name;
  int attack;
  int dodge;
  int parry;
  int turn;
  int physicalAction;

  StatusModifier(
      {required this.name,
      this.attack = 0,
      this.dodge = 0,
      this.parry = 0,
      this.turn = 0,
      this.physicalAction = 0});
}
