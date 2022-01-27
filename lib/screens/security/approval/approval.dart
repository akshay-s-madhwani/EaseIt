import 'package:ease_it/screens/security/approval/past_approvals.dart';
import 'package:ease_it/screens/security/approval/recent_approvals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Approval extends StatefulWidget {
  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Approval Status',
            style: GoogleFonts.sourceSansPro(
                fontSize: 25, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 15),
          TabBar(
              indicatorColor: Color(0xff1a73e8),
              labelColor: Colors.black,
              indicatorWeight: 2.5,
              labelStyle: GoogleFonts.sourceSansPro(
                  fontSize: 16, fontWeight: FontWeight.w600),
              tabs: [
                Tab(
                  text: 'Past',
                ),
                Tab(
                  text: 'Today',
                )
              ]),
          Expanded(
            child: TabBarView(children: [PastApproval(), RecentApproval()]),
          ),
        ]),
      ),
    );
  }
}