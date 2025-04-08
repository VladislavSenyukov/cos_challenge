class Event<T extends Object> {
  final T _content;
  bool _isConsumed = false;

  Event(this._content);

  // Returns the content and prevents it's use again.
  T? takeContent() =>
      (_isConsumed ? null : _content).also((_) => _isConsumed = true);

  @override
  String toString() => "Event(${_content.toString()})";
}

extension KotlinUtils<T, R> on T {
  T also(void Function(T it) block) {
    block.call(this);
    return this;
  }

  R? let(R? Function(T it) block) => block.call(this);
}
