class ExplainedText {
  ExplainedText({
    required this.title,
    this.text = '',
    this.explanation = '',
    this.result,
  }) {
    explanations = [];
    references = [];
  }
  String title;
  String text;
  String explanation;
  int? result;
  late List<ExplainedText> explanations;
  late List<BookReference> references;

  void addExplanation(String newExplanation) {
    explanation = '$explanation\n$newExplanation';
  }

  void addText(String newText) {
    text = '$text\n$newText';
  }

  void add({
    String? text,
    String? explanation,
    BookReference? reference,
    int? result,
  }) {
    if (text != null) this.text = this.text.isEmpty ? text : '${this.text}\n$text';
    if (explanation != null) this.explanation = this.explanation.isEmpty ? explanation : '${this.explanation}\n$explanation';
    if (reference != null) references.add(reference);
    if (result != null) this.result = result;
  }
}

class BookReference {
  BookReference({
    required this.page,
    required this.book,
  });
  int page;
  Books book;

  String get bookName {
    switch (book) {
      case Books.coreExxet:
        return 'Core Exxet';
      case Books.directorsScreen:
        return 'Pantalla del director';
    }
  }
}

enum Books { coreExxet, directorsScreen }
