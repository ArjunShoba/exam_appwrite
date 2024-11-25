import 'package:appwrite_exam/AppwriteService.dart';
import 'package:appwrite_exam/note.dart';
import 'package:flutter/material.dart';

class ExamScreen extends StatefulWidget {
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late AppwriteService _appwriteService;
  late List<Note> _notes;

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _notes = [];
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final tasks = await _appwriteService.getNotes();
      setState(() {
        _notes = tasks.map((e) => Note.fromDocument(e)).toList();
      });
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> _addNote() async {
    final name = nameController.text;
    final address = addressController.text;
    final location = locationController.text;
    final phone = phoneController.text;

    if (name.isNotEmpty &&
        address.isNotEmpty &&
        location.isNotEmpty &&
        phone.isNotEmpty) {
      try {
        await _appwriteService.addNote(name, address, location, phone);
        nameController.clear();
        addressController.clear();
        locationController.clear();
        phoneController.clear();
        _loadNotes();
      } catch (e) {
        print('Error adding note: $e');
      }
    }
  }

  Future<void> _deleteNote(String taskId) async {
    try {
      await _appwriteService.deleteNote(taskId);
      _loadNotes();
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('exam dummy')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _addNote, child: Text('Add Contact')),
            SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                height: 250,
                width: 300,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final notes = _notes[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notes.name),
                            Text(notes.address),
                            Text(notes.location),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(notes.phone),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteNote(notes.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
