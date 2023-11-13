class AttributesList {
  String? agility;
  String? constitution;
  String? dextery;
  String? strenght;
  String? intelligence;
  String? perception;
  String? might;
  String? willpower;

  AttributesList(
      {this.agility,
      this.constitution,
      this.dextery,
      this.strenght,
      this.intelligence,
      this.perception,
      this.might,
      this.willpower});

  AttributesList.fromJson(Map<String, dynamic> json) {
    agility = json['AGI'];
    constitution = json['CON'];
    dextery = json['DES'];
    strenght = json['FUE'];
    intelligence = json['INT'];
    perception = json['PER'];
    might = json['POD'];
    willpower = json['VOL'];
  }
}
