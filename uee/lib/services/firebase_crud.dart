import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('Notice');

class FirebaseCrud {
//CRUD method here
  static Future<Response> addNotice({
    required String title,
    required String massage,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "massage": massage,
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  //reading

  static Stream<QuerySnapshot> readNotice() {
    CollectionReference notesItemCollection = _Collection;

    return notesItemCollection.snapshots();
  }

//update notices
  static Future<Response> updateNotice({
    required String title,
    required String massage,
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "massage": massage,
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully updated Notice";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

//Delete notice
  static Future<Response> deleteNotice({
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully Deleted Notice";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}
