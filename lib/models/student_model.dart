import 'dart:convert';
import 'dart:io';

class StudentModel {
  String studentName;
  String studentAddress;
  String dob;
  String admissionDate;
  String mobileNo;
  List<int> subjects;
  String dobCertificate; // file path
  String attachmentExt;

  StudentModel({
    required this.studentName,
    required this.studentAddress,
    required this.dob,
    required this.admissionDate,
    required this.mobileNo,
    required this.subjects,
    required this.dobCertificate,
    required this.attachmentExt,
  });

  Map<String, dynamic> toJson() {
    // Convert file to Base64
    String base64File = "";
    if (dobCertificate.isNotEmpty) {
      final bytes = File(dobCertificate).readAsBytesSync();
      base64File = base64Encode(bytes);
    }

    return {
      "StudentName": studentName,
      "StudentAddress": studentAddress,
      "DOB": dob,
      "DateOfAddmition": admissionDate,
      "MobileNo": mobileNo,
      "DOBCertificate": base64File,
      "AttchmentExt": attachmentExt,
      "subject": subjects.map((id) => {"SubjectId": id.toString()}).toList(),
    };
  }
}