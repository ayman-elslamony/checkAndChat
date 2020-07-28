import 'package:flutter/foundation.dart';

class Appointment {
  final int id;
  final String day;
  final String date;
  final String duration;
  final String time;
  final String availability;
  final String doc_id;
  final String patient_id;
  final String pharmacy_id;
  final String lap_id;
  final String doc_name;
  final String medical_report;

  Appointment({
    @required this.id,
    @required this.day,
    @required this.date,
    @required this.duration,
    @required this.time,
    @required this.availability,
    @required this.doc_id,
    @required this.patient_id,
    @required this.pharmacy_id,
    @required this.lap_id,
    @required this.doc_name,
    @required this.medical_report,
  });
}
