class ExplainedText {
  String title;
  String text;
  String explanation;
  int? result;
  late List<ExplainedText> explanations;
  late List<BookReference> references;

  ExplainedText({
    required this.title,
    this.text = "",
    this.explanation = "",
    this.result,
  }) {
    explanations = [];
    references = [];
  }

  addExplanation(String newExplanation) {
    explanation = "$explanation\n$newExplanation";
  }

  addText(String newText) {
    text = "$text\n$newText";
  }

  add({
    String? text,
    String? explanation,
    BookReference? reference,
    int? result,
  }) {
    if (text != null) this.text = this.text.isEmpty ? text : "${this.text}\n$text";
    if (explanation != null) this.explanation = this.explanation.isEmpty ? explanation : "${this.explanation}\n$explanation";
    if (reference != null) references.add(reference);
    if (result != null) this.result = result;
  }
}

class BookReference {
  int page;
  Books book;

  BookReference({
    required this.page,
    required this.book,
  });
}

enum Books { coreExxet, directorsScreen }
