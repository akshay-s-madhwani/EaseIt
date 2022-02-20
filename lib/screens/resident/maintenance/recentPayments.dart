import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/screens/resident/maintenance/transactionHistory.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:flutter/material.dart';

class RecentPayments extends StatefulWidget {
  const RecentPayments({ Key key }) : super(key: key);

  @override
  _RecentPaymentsState createState() => _RecentPaymentsState();
}

class _RecentPaymentsState extends State<RecentPayments> {
  final db = FirebaseFirestore.instance;
  Globals g = Globals();
  int noOfBills = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true, children: [
        StreamBuilder<QuerySnapshot>(
          stream: Database().fetchMaintenance(g.society),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(              
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: snapshot.data.docs.map((doc) {
                  print(doc["name"]);
                  if(doc["status"] == "Paid" && noOfBills < 5){      
                    noOfBills++;            
                    return TransactionBill(
                      name: doc["name"],
                      wing: doc["wing"],
                      flatNo: doc["flatNo"],
                      transactionAmount: doc["billAmount"],
                      transactionDate: doc["datePaid"],
                      month: doc["month"],
                      status: doc["status"],
                      payable: false
                    );
                  }
                  else
                    return Container();
                }).toList(),          
            );
          }
          else
          return Container();
          }),
        ],
      ),
    );
  }
}