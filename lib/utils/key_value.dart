class KeyValue {

  KeyValue({required this.key, required this.value});
  final String key;
  final String value;

  @override
  String toString() {
    return '$key: $value';
  }
}

extension ListToKeyValue on Map<String, dynamic> {
  List<KeyValue> list({bool interchange = false}) {
    final list = <KeyValue>[];
    for (final entry in entries) {
      list.add(
        KeyValue(
          key: interchange ? entry.value.toString() : entry.key,
          value: interchange ? entry.key : entry.value.toString(),
        ),
      );
    }
    return list;
  }
}
