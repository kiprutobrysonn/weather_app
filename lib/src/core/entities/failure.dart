class Failure {
  final String message;
  final String? extraData;

  const Failure(this.message, {this.extraData});

  @override
  String toString() {
    return 'Failure{message: $message, extraData: $extraData}';
  }
}
