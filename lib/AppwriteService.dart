import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  late Client client;
  late Databases databases;
  static const endPoint = "https://cloud.appwrite.io/v1";
  static const projectid = "6743dd2b00082d133aca";
  static const databaseid = "6743dea3003cf5184d38";
  static const collectionid = "6743e106002c243e75f4";

  AppwriteService() {
    client = Client();
    client.setEndpoint(endPoint);
    client.setProject(projectid);
    databases = Databases(client);
  }

  /// Fetch all notes
  Future<List<Document>> getNotes() async {
    try {
      final result = await databases.listDocuments(
        collectionId: collectionid,
        databaseId: databaseid,
      );
      return result.documents;
    } catch (e) {
      print('Error loading notes: $e');
      rethrow;
    }
  }

  /// Add a new note
  Future<Document> addNote(
      String name, String address, String location, String phone) async {
    try {
      final documentId = ID.unique();

      final result = await databases.createDocument(
        collectionId: collectionid,
        databaseId: databaseid,
        data: {
          'name': name,
          'address': address,
          'location': location,
          'phone': phone,
        },
        documentId: documentId,
      );
      return result;
    } catch (e) {
      print('Error creating note: $e');
      rethrow;
    }
  }

  /// Delete a note by its ID
  Future<void> deleteNote(String documentId) async {
    try {
      await databases.deleteDocument(
        collectionId: collectionid,
        documentId: documentId,
        databaseId: databaseid,
      );
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }
}
