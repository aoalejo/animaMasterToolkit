extension Abbreviation on String {
  String get abbreviated {
    // Extract the first character out of each block of non-whitespace
    final initials = split(' ').map((word) => word.isEmpty
        ? ''
        : word.substring(
            0,
            word.length > 4
                // For words with "rr" or "ll", don't cut in the middle
                ? word[2] == word[3]
                    ? 4
                    : 3
                : word.length,),);
    var result = initials.first;

    if (initials.length == 1) {
      return this;
    }

    for (final element in initials) {
      final intValue = int.tryParse(element);

      if (initials.first != element) {
        if (intValue != null || initials.last == element || element.length == 1) {
          result = '$result $element';
        }
      }
    }

    return result;
  }
}
