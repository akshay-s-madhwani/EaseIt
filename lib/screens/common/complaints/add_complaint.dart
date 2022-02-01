import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/firebase/storage.dart';
import 'package:ease_it/utility/alert.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/loading.dart';
import 'package:ease_it/utility/pick_image.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AddComplaint extends StatefulWidget {
  @override
  _AddComplaintState createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  File _profilePicture;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Globals g = Globals();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(Icons.keyboard_backspace, color: Colors.black),
              SizedBox(width: 5),
              Text(
                'Back',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: [
                  Text(
                    'Help your society improve!!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Post your complaint / suggestion below',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () async {
                      _profilePicture = await PickImage().showPicker(context);
                      setState(() {});
                    },
                    child: Container(
                      child: Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _profilePicture == null
                              ? AssetImage('assets/dummy_image.jpg')
                              : FileImage(_profilePicture),
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter a title'),
                          maxLines: null,
                          controller: _titleController,
                          validator: (value) =>
                              value.length == 0 ? 'Please enter a title' : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Enter description'),
                          maxLines: null,
                          controller: _descController,
                          validator: (value) => value.length == 0
                              ? 'Please enter description'
                              : null,
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                bool confirmation = await showConfirmationDialog(
                                    context,
                                    "Alert!",
                                    "Are you sure you want to add this complaint?");
                                if (confirmation) {
                                  setState(() => loading = true);
                                  String imageUrl = _profilePicture == null
                                      ? ""
                                      : await Storage().storeImage(
                                          'complaints',
                                          (DateTime.now()
                                                      .millisecondsSinceEpoch /
                                                  1000)
                                              .toString(),
                                          _profilePicture);
                                  Database()
                                      .addComplaint(
                                          g.society,
                                          _titleController.text,
                                          _descController.text,
                                          imageUrl ?? "",
                                          "${g.fname} ${g.lname} (${g.wing}-${g.flatNo})")
                                      .then((value) {
                                    setState(() => loading = false);
                                    showToast(context, "success", "Success!",
                                        "Complaint added successfully");
                                  }).catchError(() {
                                    setState(() => loading = false);
                                    showToast(context, "error", "Oops!",
                                        "Something went wrong");
                                  });
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              child: Text(
                                'Publish',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff1a73e8)),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
