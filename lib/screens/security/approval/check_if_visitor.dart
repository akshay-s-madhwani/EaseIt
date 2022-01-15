import 'package:ease_it/screens/security/approval/custom_dialog.dart';
import 'package:ease_it/screens/security/security.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:animate_icons/animate_icons.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'upload_visitor_data.dart';

// ignore: must_be_immutable
class CheckIfVisitor extends StatefulWidget {
  // const CheckIfVisitor({ Key? key }) : super(key: key);
  String vehicleNo,status;
  CheckIfVisitor(this.status, this.vehicleNo, {Key key}) : super(key: key);

  @override
  _CheckIfVisitorState createState() => _CheckIfVisitorState();
}

class _CheckIfVisitorState extends State<CheckIfVisitor> with TickerProviderStateMixin {
  TextEditingController visitorNameController = TextEditingController();
  TextEditingController flatNoController = TextEditingController();
  TextEditingController wingController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isVisitor = true;
  final db = FirebaseFirestore.instance;
  String type = "Resident";

  @override
  void initState(){
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection("Vehicle_Info").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              String ss = snapshot.data.docs[i]["vehicleNo"].toString().toLowerCase();
              print(ss + " ss");
              print(widget.vehicleNo.toLowerCase());
              print(ss.compareTo(widget.vehicleNo.toLowerCase()));
              if (ss.compareTo(widget.vehicleNo.toLowerCase()) == 0) {
                isVisitor = false;
                break;
              }
            }
          }
          if (isVisitor == false || widget.status == "Exit"){
            if(isVisitor)
              type = "Visitor";
            else{
              type = "Resident";
              print("Res");
            }
            // final _animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
            //uploadResidentData(flatNoController.text, widget.vehicleNo, entry, time);
            return Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Image(
                        image: new AssetImage('assets/images/check-mark-verified.gif')
                      )
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Vehicle Belongs to $type. Allow ${widget.status}",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () { 
                          if(type == "Visitor")
                            uploadVisitorData(visitorNameController.text, wingController.text, flatNoController.text, widget.vehicleNo, phoneNumberController.text, widget.status);                      
                          else
                            uploadResidentData(flatNoController.text, wingController.text,widget.vehicleNo, widget.status);                      

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Security()),
                          );
                        },
                        child: const Text('Home Page',                      
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),  
                        ),
                      ),
                    ),    
                  ]
                )
              )
            // child: ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   backgroundColor: Colors.blue,
            //   elevation: 10,
            //   padding: EdgeInsets.all(1),
            //   content: Text('User is Resident. Allow Entry')));
            );          
          }
          else{
            print("Visitor");
            return Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Text("Hello Visitor",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        // backgroundColor: Colors.blue,
                        color: Colors.blue
                      ),
                    ),
                  ),       
                  const SizedBox(
                    height: 30
                  ),          
                  TextField(
                    controller: visitorNameController,
                    decoration: const InputDecoration(  
                      labelText: 'Visitor Name',  
                    ),  
                  ),
                  const SizedBox(
                    height: 10
                  ),                    
                  TextField(
                    controller: wingController,
                    decoration: const InputDecoration(  
                      labelText: 'Wing',  
                    ),  
                  ),
                  const SizedBox(
                    height: 10
                  ),                    
                  TextField(
                    controller: flatNoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(  
                      labelText: 'Flat No. Visiting',  
                    ),  
                  ),
                  const SizedBox(
                    height: 10
                  ),                    
                  TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(  
                      labelText: 'Phone Number',  
                    ),  
                  ),                    
                  const SizedBox(
                    height: 10
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () { 
                        uploadVisitorData(visitorNameController.text, wingController.text, flatNoController.text, widget.vehicleNo, phoneNumberController.text, widget.status);                      
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UploadToDatabase(
                            visitorNameController.text,
                            flatNoController.text,
                            widget.vehicleNo,
                            phoneNumberController.text
                          )),
                        );
                      },
                      child: const Text('Upload Info To Database',                      
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),  
                      ),
                    ),
                  ),
              ],),
              ),
            );
          }
        },
      ),
    );              
  }

  final visLog = FirebaseFirestore.instance.collection('Visitor_Log');

  Future<void> uploadVisitorData(String name, String wing, String flatNo, String vehicleNo, String phoneNo, String status){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM y kk:mm').format(now);
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "Pending Approval",
        description: "Approval Request Sent to Resident at $wing-$flatNo",
        buttonText: "Okay",
      ),
    );
    return visLog
      .add({
        "visitorName": name,
        "flatNo": flatNo,
        "vehicleNo": vehicleNo,
        "phoneNo": phoneNo,
        "status": status,
        "time": formattedDate,
      })
      .then(
        (value) => print("Visitor Log Uploaded on Firestore"),
      )
      .catchError(
        (error) => print("Failed to add Visitor Log: $error"),
      );
    }

  final resLog = FirebaseFirestore.instance.collection('Resident_Log');
  Future<void> uploadResidentData(String wing, String flatNo, String vehicleNo, String status){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM y kk:mm').format(now);
    return resLog
      .add({
        "flatNo": flatNo,
        "vehicleNo": vehicleNo,
        "status": status,
        "time": formattedDate,
      })
      .then(
        (value) => print("Resident Log Uploaded on Firestore"),
      )
      .catchError(
        (error) => print("Failed to add Resident Log: $error"),
      );
  }  
}  
  