import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/notice.dart';
import 'package:flutter_application_1/page/addpage.dart';
import 'package:flutter_application_1/page/edit.dart';
import 'package:flutter/material.dart';

import '../services/firebase_crud.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ListPage> {
  final Stream<QuerySnapshot> collectionReference = FirebaseCrud.readNotice();
  //FirebaseFirestore.instance.collection('Employee').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("List of Employee"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.app_registration,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => AddPage(),
                ),
                (route) =>
                    false, //if you want to disable back feature set to false
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView(
                children: snapshot.data!.docs.map((e) {
                  return Card(
                      child: Column(children: [
                    ListTile(
                      title: Text(e["title"]),
                      subtitle: Container(
                        child: (Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("massage: " + e['massage'],
                                style: const TextStyle(fontSize: 14)),
                          ],
                        )),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(5.0),
                            primary: const Color.fromARGB(255, 143, 133, 226),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('Edit'),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => EditPage(
                                  notice: Notice (
                                    nid: e.id,
                                    title: e["title"],
                                    massage: e["massage"],
                                  ),
                                ),
                              ),
                              (route) =>
                                  false, //if you want to disable back feature set to false
                            );
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(5.0),
                            primary: const Color.fromARGB(255, 143, 133, 226),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('Delete'),
                          onPressed: () async {
                            var response =
                                await FirebaseCrud.deleteNotice(docId: e.id);
                            if (response.code != 200) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content:
                                          Text(response.message.toString()),
                                    );
                                  });
                            }
                          },
                        ),
                      ],
                    ),
                  ]));
                }).toList(),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
