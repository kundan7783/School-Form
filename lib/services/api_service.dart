import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_model.dart';
import '../models/subject_model.dart';

class ApiService {

  static const baseUrl = "http://angulartest.ducem.in/api";

  static Future<List<SubjectModel>> getSubjects() async {

    final response = await http.post(
      Uri.parse("$baseUrl/Candidate/GetSubjectList"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      List list = data["Table"];

      return list.map((e) => SubjectModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load subjects");
    }
  }


  static Future<bool> saveStudent(StudentModel student) async {

    final response = await http.post(
      Uri.parse("$baseUrl/Candidate/SaveStudentDetails"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(student.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}