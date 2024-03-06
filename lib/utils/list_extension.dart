extension NullableElement<E> on List<E> {
  void tryAdd(E? element) {
    if (element == null) return;

    add(element);
  }
}
