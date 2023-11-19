class POSMStore {
  String storeId;
  String pposmId;
  String question1;
  String question2;
  String question3;
  String question4;
  String question5;
  String description;

  POSMStore(
      {required this.storeId,
      required this.pposmId,
      required this.question1,
      required this.question2,
      required this.question3,
      required this.question4,
      required this.question5,
      required this.description});

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'pposmId': pposmId,
      'question1': question1,
      'question2': question2,
      'question3': question3,
      'question4': question4,
      'question5': question5,
      'description': description
    };
  }

  factory POSMStore.fromJson(dynamic json) {
    return POSMStore(
        storeId: json['storeId'],
        pposmId: json['pposmId'],
        question1: json['question1'],
        question2: json['question2'],
        question3: json['question3'],
        question4: json['question4'],
        question5: json['question5'],
        description: json['description']);
  }
}
