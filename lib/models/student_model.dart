class StudentModel {

  String studentName;
  String studentAddress;
  String dob;
  String admissionDate;
  String mobileNo;
  List<int> subjects;

  StudentModel({
    required this.studentName,
    required this.studentAddress,
    required this.dob,
    required this.admissionDate,
    required this.mobileNo,
    required this.subjects,
  });

  Map<String, dynamic> toJson() {
    return {
      "StudentName": studentName,
      "StudentAddress": studentAddress,
      "DOB": dob,
      "DateOfAdmission": admissionDate,
      "MobileNo": mobileNo,
      "DOBCertificate": "",
      "AttachmentExt": "",
      "subject": subjects.map((e) => {"SubjectId": e.toString()}).toList(),
    };
  }
}