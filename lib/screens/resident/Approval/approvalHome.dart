// import 'dart:html';

// import 'dart:js';

import 'package:ease_it/screens/common/complaints/add_complaint.dart';
import 'package:ease_it/screens/resident/Approval/addHelper.dart';
import 'package:ease_it/screens/resident/Approval/allActivities.dart';
import 'package:ease_it/screens/resident/Approval/preapproval.dart';
import 'package:ease_it/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Approval extends StatefulWidget {
  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(children: [
                  Text('Recent Visitor', style: Helper().headingStyle)
                ]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // NewWidget(),
                        CircularButtonIcon(
                            firstName: "Pre",
                            lastName: "Approve",
                            imageLink: 'assets/add-user.png',
                            type: 'preApprove'),

                        CircularImageIcon(
                            firstName: "Amol",
                            lastName: "Thopate",
                            imageLink:
                                'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg'),
                        CircularImageIcon(
                            firstName: "Ramu",
                            lastName: "Thopate",
                            imageLink:
                                'https://lh3.googleusercontent.com/mT4DqgvnPFpzmHQrPV66ud9kUrdBd4wSjR90HyPxn2F5qYn2QuChVy1m_yKU_Awd5_tyqifHElUBh4YkbTZ1HsmT'),
                        CircularImageIcon(
                            firstName: "Himesh",
                            lastName: "Thopate",
                            imageLink:
                                'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l'),
                        CircularImageIcon(
                            firstName: "Salman",
                            lastName: "Thopate",
                            imageLink:
                                'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTOj2HVmgtYgoxxh9hcakq_c_SmfqtFeciy7QJRGA0bfkPeHkAU'),
                        CircularImageIcon(
                            firstName: "Akshay",
                            lastName: "Thopate",
                            imageLink:
                                'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg'),
                        CircularImageIcon(
                            firstName: "Amol",
                            lastName: "Thopate",
                            imageLink:
                                'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg')
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Daily Helper",
                      style: Helper().headingStyle,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // NewWidget(),
                        CircularButtonIcon(
                            firstName: "Add",
                            lastName: "Helper",
                            imageLink: 'assets/add-user.png',
                            type: "addHelper"),

                        CircularImageIcon(
                            firstName: "Amol",
                            lastName: "Thopate",
                            imageLink:
                                'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg'),
                        CircularImageIcon(
                            firstName: "Ramu",
                            lastName: "Thopate",
                            imageLink:
                                'https://lh3.googleusercontent.com/mT4DqgvnPFpzmHQrPV66ud9kUrdBd4wSjR90HyPxn2F5qYn2QuChVy1m_yKU_Awd5_tyqifHElUBh4YkbTZ1HsmT'),
                        CircularImageIcon(
                          firstName: "Himesh",
                          lastName: "Thopate",
                          imageLink:
                              'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcTJVo-u1t23uZ8aD32_1LfeA0vVYHUGaBWPoR7nGSM4Z37vej_l',
                        ),
                        CircularImageIcon(
                            firstName: "Salman",
                            lastName: "Thopate",
                            imageLink:
                                'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTOj2HVmgtYgoxxh9hcakq_c_SmfqtFeciy7QJRGA0bfkPeHkAU'),
                        CircularImageIcon(
                            firstName: "Akshay",
                            lastName: "Thopate",
                            imageLink:
                                'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg'),
                        CircularImageIcon(
                            firstName: "Amol",
                            lastName: "Thopate",
                            imageLink:
                                'https://m.media-amazon.com/images/M/MV5BYzMwMmVlODYtN2M0MS00Y2Q4LWI1N2ItYzljYzNlMTI5YjI4XkEyXkFqcGdeQXVyMTYwNjkzNDc@._V1_UY180_CR45,0,180,180_AL_.jpg')
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text("Child Approval", style: Helper().headingStyle),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NewWidget(),
                      CircularButtonIcon(
                          firstName: "Child",
                          lastName: "Approve",
                          imageLink: 'assets/child.png',
                          type: "approveChild"),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customOutlinedButton(
                          "View All Activites",
                          Icons.access_time,
                          () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActivityLog(),
                                  ),
                                )
                              }),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class CircularButtonIcon extends StatelessWidget {
  final String firstName, lastName, type, imageLink;

  CircularButtonIcon(
      {this.firstName, this.lastName, this.imageLink, this.type});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (type) {
          case "preApprove":
            {
              return showDialog(
                  context: context, builder: (context) => PreApproval());
            }
            break;
          case "addHelper":
            {
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddHelper(),
                ),
              );
            }
            break;
          case "complaint":
            {
              return Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddComplaint()));
            }
            break;
          case "approveChild":
            {
              TextEditingController nameController = TextEditingController();
              TextEditingController phoneController = TextEditingController();
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: Text("Allow my child to Exit",
                          style: Helper().headingStyle),
                      content: Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: const Color(0xFFFFFF),
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(32.0)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter Name',
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                              controller: nameController,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter hrs',
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                              keyboardType: TextInputType.number,
                              controller: phoneController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: () async {
                                print(phoneController.text);
                                print(nameController.text);

                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff1a73e8)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(50, 8, 50, 8),
                                child: Text(
                                  'Generate Token',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )));
            }
        }
      },
      child: Container(
        // width: 45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(imageLink), fit: BoxFit.fill),
                ),
              ),
            ),
            Text(firstName, style: Helper().normalStyle),
            Text(lastName, style: Helper().normalStyle)
          ],
        ),
      ),
    );
  }
}

class CircularImageIcon extends StatelessWidget {
  final String firstName, lastName, imageLink;
  final Function operation;

  CircularImageIcon(
      {this.firstName, this.lastName, this.imageLink, this.operation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: operation,
        child: Container(
          width: 55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(imageLink), fit: BoxFit.fill),
                ),
              ),
              Text(firstName, style: Helper().normalStyle),
              Text(lastName, style: Helper().normalStyle)
            ],
          ),
        ),
      ),
    );
  }
}

Widget customOutlinedButton(String name, IconData icon, Function operation) {
  return OutlinedButton.icon(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (!states.contains(MaterialState.pressed))
            return Helper().button.withOpacity(1);
          return null; // Use the component's default.
        },
      ),
    ),
    onPressed: operation,
    label: Text(name, style: Helper().buttonTextStyle),
    icon: Icon(
      icon,
      size: 15,
      color: Colors.blue,
    ),
  );
}