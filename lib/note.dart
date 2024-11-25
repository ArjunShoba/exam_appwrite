import 'package:appwrite/models.dart';

class Note  {
  final String id;
  final String name;
  final String address;
  final String location;
  final String phone;

  Note({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.phone,
  });

  factory Note.fromDocument(Document doc) {
    return Note(
      id: doc.$id,
      name: doc.data['name'],
      address: doc.data['address'],
      location: doc.data['location'],
      phone: doc.data['phone'],
    );
  }
}