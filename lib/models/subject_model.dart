class SubjectModel {
  final int id;
  final String name;
  bool isSelected;

  SubjectModel({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['Sub_Id'],
      name: json['Sub_Name'],
    );
  }
}