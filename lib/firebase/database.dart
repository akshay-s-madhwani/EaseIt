// Cloud Firestore functions

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ease_it/flask/api.dart';
import 'package:ease_it/utility/variables/globals.dart';
import 'package:ease_it/utility/acknowledgement/notification.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Database {
  Globals g = Globals();
  final _firestore = FirebaseFirestore.instance;

  Future<List<String>> getAllSocieties() async {
    List<String> societies = [];
    await _firestore.collection('Society').get().then((value) {
      value.docs.forEach((doc) {
        societies.add(doc.id);
      });
    });
    return societies;
  }

  Future getSocietyInfo(String societyName) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('Society').doc(societyName).get();
      return snap.data();
    } catch (e) {
      e.toString();
      return null;
    }
  }

  Future<bool> checkRegisteredUser(String society, String email) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('email', isEqualTo: email)
          .get();
      if (snapshot.size == 0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future createUser(
    String society,
    String uid,
    String fname,
    String lname,
    String email,
    String phoneNum,
    String role, [
    String homeRole,
    Map<dynamic, dynamic> flat,
  ]) async {
    // Generate unique token for device to send notification
    String token = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.instance.subscribeToTopic('general');
    try {
      if (role == 'Resident') {
        await _firestore
            .collection(society)
            .doc('users')
            .collection('User')
            .doc(uid)
            .set({
          'imageUrl': '',
          'fname': fname,
          'lname': lname,
          'email': email,
          'phoneNum': phoneNum,
          'role': role,
          'flat': flat,
          'homeRole': homeRole,
          'status': 'pending',
          'token': token,
        });
      } else {
        await _firestore
            .collection(society)
            .doc('users')
            .collection('User')
            .doc(uid)
            .set({
          'imageUrl': '',
          'fname': fname,
          'lname': lname,
          'email': email,
          'phoneNum': phoneNum,
          'role': role,
          'status': 'pending',
          'token': token,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateUserDetails(String societyName, String uid, String fname,
      String lname, String email, String phoneNumber, String imageUrl) async {
    try {
      return await _firestore
          .collection(societyName)
          .doc('users')
          .collection('User')
          .doc(uid)
          .update({
        'fname': fname,
        'lname': lname,
        'email': email,
        'phoneNum': phoneNumber,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future getUserDetails(String societyName, String uid) async {
    try {
      return await _firestore
          .collection(societyName)
          .doc('users')
          .collection('User')
          .doc(uid)
          .get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Complaints queries
  Stream<QuerySnapshot> fetchComplaints(String societyName,
      [bool recent = false]) {
    try {
      if (recent) {
        return _firestore
            .collection(societyName)
            .doc('complaints')
            .collection('Complaint')
            .where('postedOn',
                isGreaterThan: DateTime.now().subtract(Duration(days: 1)))
            .snapshots();
      } else {
        return _firestore
            .collection(societyName)
            .doc('complaints')
            .collection('Complaint')
            .orderBy('postedOn', descending: true)
            .snapshots();
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> addComplaint(
      String id,
      String societyName,
      String title,
      String description,
      List<String> imageUrl,
      String postedBy,
      List statusObjectMap) async {
    try {
      await _firestore
          .collection(societyName)
          .doc('complaints')
          .collection('Complaint')
          .doc(id)
          .set({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'status': 'Unresolved',
        'postedBy': postedBy,
        'postedOn': DateTime.now(),
        'likes': Map<String, dynamic>(),
        'progress': statusObjectMap,
      });
      // sendNotification(
      //     '/topics/general', 'New complaint posted by someone', title);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateLikes(
      String id, String society, Map<String, dynamic> likes) async {
    print(likes);
    try {
      await _firestore
          .collection(society)
          .doc('complaints')
          .collection('Complaint')
          .doc(id)
          .update({'likes': likes});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> markResolved(String id, String societyName, List temp) async {
    try {
      await _firestore
          .collection(societyName)
          .doc('complaints')
          .collection('Complaint')
          .doc(id)
          .update({
        'status': 'Resolved',
        'progress': temp,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Notice queries
  Stream<QuerySnapshot> fetchNotices(String societyName,
      [bool recent = false]) {
    try {
      if (recent) {
        return _firestore
            .collection(societyName)
            .doc('notices')
            .collection('Notice')
            .where('postedOn',
                isGreaterThan: DateTime.now().subtract(Duration(days: 1)))
            .snapshots();
      } else {
        return _firestore
            .collection(societyName)
            .doc('notices')
            .collection('Notice')
            .snapshots();
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<DocumentSnapshot> userStream(String societyName, String uid) {
    try {
      return _firestore
          .collection(societyName)
          .doc('users')
          .collection('User')
          .doc(uid)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Maintenance queries
  Stream<QuerySnapshot> fetchMaintenance(String societyName) {
    try {
      return _firestore
          .collection(societyName)
          .doc('maintenance')
          .collection('Maintenance')
          .orderBy('datePaid', descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Resident Fetch queries
  Stream<QuerySnapshot> fetchResidentsOfSociety(String societyName) {
    try {
      return _firestore
          .collection(societyName)
          .doc('users')
          .collection('User')
          .where('role', isNotEqualTo: "Security Guard")
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<bool> addNotice(String societyName, String title, String body) async {
    try {
      await _firestore
          .collection(societyName)
          .doc('notices')
          .collection('Notice')
          .add({'title': title, 'body': body, 'postedOn': DateTime.now()});
      sendNotification('/topics/general', 'New notice', title);
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  // Events queries
  Stream<QuerySnapshot> fetchPastEvents(String societyName) {
    try {
      return _firestore
          .collection(societyName)
          .doc('events')
          .collection('Event')
          .where('date', isLessThan: DateTime.now())
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<QuerySnapshot> fetchUpcomingEvents(String societyName) {
    try {
      return _firestore
          .collection(societyName)
          .doc('events')
          .collection('Event')
          .where('date', isGreaterThanOrEqualTo: DateTime.now())
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> addEvent(String societyName, String name, String venue,
      DateTime date, bool isFullDayEvent,
      [String from, String to]) async {
    try {
      if (isFullDayEvent) {
        await _firestore
            .collection(societyName)
            .doc('events')
            .collection('Event')
            .add({
          'isFullDay': true,
          'name': name,
          'venue': venue,
          'date': date,
        });
      } else {
        await _firestore
            .collection(societyName)
            .doc('events')
            .collection('Event')
            .add({
          'isFullDay': false,
          'name': name,
          'venue': venue,
          'date': date,
          'from': from,
          'to': to
        });
      }
      sendNotification('/topics/general', 'New event', name);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addMaintenance(
      String societyName, String billAmount, String month) async {
    QuerySnapshot snap = await _firestore
        .collection(societyName)
        .doc('users')
        .collection('User')
        .where('status', isEqualTo: "accepted")
        .where('homeRole', isEqualTo: "Owner")
        .get();

    snap.docs.forEach((doc) {
      return _firestore
          .collection(societyName)
          .doc('maintenance')
          .collection('Maintenance')
          .add({
        'status': "Pending",
        'billAmount': billAmount,
        'month': month,
        'datePaid': "",
        'name': doc["fname"],
        'flat': doc["flat"],
      });
    });
  }

  Future<void> markMaintenanceAsPaid(
      String societyName, String month, String billAmount) async {
    // print("12Inside Add Maintenance");
    String docID = "";
    QuerySnapshot snap = await _firestore
        .collection(societyName)
        .doc('maintenance')
        .collection('Maintenance')
        .where('flat', isEqualTo: Map<String, String>.from(g.flat))
        .where('month', isEqualTo: month)
        .get();

    snap.docs.forEach((doc) {
      docID = doc.id.toString();
    });

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    return _firestore
        .collection(societyName)
        .doc('maintenance')
        .collection('Maintenance')
        .doc(docID)
        .update({'status': "Paid", 'datePaid': formattedDate});
  }

  // Vehicle management queries
  Future<void> addVehicle(
    String societyName,
    String imageUrl,
    String licensePlateNo,
    String model,
    String parkingSpaceNo,
    String vehicleType,
    Map<String, String> flat,
    //String wing,
    //String flatNo,
  ) async {
    try {
      await _firestore
          .collection(societyName)
          .doc('vehicles')
          .collection('Vehicle')
          .add({
        'imageUrl': imageUrl,
        'licensePlateNo': licensePlateNo,
        'model': model,
        'parkingSpaceNo': parkingSpaceNo,
        'vehicleType': vehicleType,
        'flat': flat,
        //'wing': wing,
        //'flatNo': flatNo
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<QuerySnapshot> getMyVehicle(
    String societyName,
    //String wing,
    Map<String, String> flat,
  ) async {
    try {
      return await _firestore
          .collection(societyName)
          .doc('vehicles')
          .collection('Vehicle')
          .where('flat', isEqualTo: flat)
          //.where('wing', isEqualTo: wing)
          //.where('flatNo', isEqualTo: flatNo)
          .get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<QuerySnapshot> searchVehicle(
      String society, String licensePlateNo) async {
    try {
      return await _firestore
          .collection(society)
          .doc('vehicles')
          .collection('Vehicle')
          .where('licensePlateNo', isEqualTo: licensePlateNo)
          .get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<QuerySnapshot> getAllVehicles(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('vehicles')
          .collection('Vehicle')
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Visitor vehicle log
  Future<void> logVisitorVehicleEntry(
      String society,
      String licensePlateNo,
      //String flatNo, String wing,
      Map<String, String> flat,
      String purpose,
      [String id]) async {
    try {
      if (id != null) {
        await _firestore
            .collection(society)
            .doc('vehicleLog')
            .collection('Vehicle Log')
            .doc(id)
            .set({
          'licensePlateNo': licensePlateNo,
          //'flatNo': flatNo,
          //'wing': wing,
          'flat': flat,
          'purpose': purpose,
          'entryTime': DateTime.now(),
          'exitTime': null,
        });
      } else {
        await _firestore
            .collection(society)
            .doc('vehicleLog')
            .collection('Vehicle Log')
            .add({
          'licensePlateNo': licensePlateNo,
          'flat': flat,
          //'flatNo': flatNo,
          //'wing': wing,
          'purpose': purpose,
          'entryTime': DateTime.now(),
          'exitTime': null,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> logVisitorVehicleExit(
      String society, String licensePlateNo) async {
    try {
      QuerySnapshot qs = await _firestore
          .collection(society)
          .doc('vehicleLog')
          .collection('Vehicle Log')
          .where('licensePlateNo', isEqualTo: licensePlateNo)
          .where('exitTime', isNull: true)
          .get();

      String uid = qs.docs[0].id;
      await _firestore
          .collection(society)
          .doc('vehicleLog')
          .collection('Vehicle Log')
          .doc(uid)
          .update({'exitTime': DateTime.now()});

      // Check if vehicle was assigned parking and if yes delete assignment
      qs = await _firestore
          .collection(society)
          .doc('parkingAssignment')
          .collection('Parking Assignment')
          .where('licensePlateNo', isEqualTo: licensePlateNo)
          .get();
      if (qs.size > 0) {
        qs.docs.forEach((doc) async {
          await API().disAllocateParking(
              society.replaceAll(" ", "").toLowerCase(), doc['parkingSpace']);
          await _firestore
              .collection(society)
              .doc('parkingAssignment')
              .collection('Parking Assignment')
              .doc(doc.id)
              .delete();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Parking space assignment
  Future<DocumentReference> saveParkingDetails(
      String society,
      String licensePlateNo,
      String owner,
      String phoneNum,
      String parkingSpace,
      int stayTime) async {
    try {
      return await _firestore
          .collection(society)
          .doc('parkingAssignment')
          .collection('Parking Assignment')
          .add({
        'licensePlateNo': licensePlateNo,
        'owner': owner,
        'phoneNum': phoneNum,
        'parkingSpace': parkingSpace,
        'timestamp': DateTime.now(),
        'stayTime': stayTime
      });
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> updateParkingSpace(
      String society, String docId, String parkingSpace) async {
    try {
      await _firestore
          .collection(society)
          .doc('parkingAssignment')
          .collection('Parking Assignment')
          .doc(docId)
          .update({'parkingSpace': parkingSpace});
    } catch (e) {
      print(e.toString());
    }
  }

  // Get all parked vehicles information
  Stream<QuerySnapshot> getParkingStatus(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('parkingAssignment')
          .collection('Parking Assignment')
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Get vehicle log
  Stream<QuerySnapshot> getvehicleLog(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('vehicleLog')
          .collection('Vehicle Log')
          .orderBy('entryTime', descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Get single vehicle log
  Future<DocumentSnapshot> getSingleVehicleLog(
      String society, String docId) async {
    try {
      return _firestore
          .collection(society)
          .doc('vehicleLog')
          .collection('Vehicle Log')
          .doc(docId)
          .get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Child approval
  Stream<QuerySnapshot> getPastChildApproval(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('childApprovals')
          .collection('ChildApproval')
          .where('date', isLessThan: DateTime.now().subtract(Duration(days: 1)))
          .orderBy('date', descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<QuerySnapshot> getRecentChildApproval(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('childApprovals')
          .collection('ChildApproval')
          .where('date',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(Duration(days: 1)))
          .orderBy('date', descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> sendChildApprovalRequest(
      String society, String name, String age, Map<String, String> flat
      //String wing, String flatNo,
      ) async {
    try {
      await _firestore
          .collection(society)
          .doc('childApprovals')
          .collection('ChildApproval')
          .add({
        'name': name,
        'age': age,
        'flat': flat,
        //'wing': wing,
        //'flatNo': flatNo,
        'date': DateTime.now(),
        'status': 'Pending'
      });

      // Send notification to every person of that flat
      _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('flat', isEqualTo: flat)
          //.where('wing', isEqualTo: wing)
          //.where('flatNo', isEqualTo: flatNo)
          .get()
          .then((qs) {
        qs.docs.forEach((doc) {
          sendNotification(doc['token'], 'New Child Approval',
              'You have a new approval for your child $name');
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Fetching all child Approval
  Stream<QuerySnapshot> getAllChildApproval(
    String society,
    Map<String, String> flat,
    //String wing,
  ) {
    try {
      return _firestore
          .collection(society)
          .doc('childApprovals')
          .collection('ChildApproval')
          .where('flat', isEqualTo: flat)
          //.where('wing', isEqualTo: wing)
          //.where('flatNo', isEqualTo: flatNo)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Fetching pending child approval
  Stream<QuerySnapshot> getPendingChildApproval(
    String society,
    Map<String, String> flat,
    //String wing,
  ) {
    try {
      return _firestore
          .collection(society)
          .doc('childApprovals')
          .collection('ChildApproval')
          .where('status', isEqualTo: "Pending")
          .where('flat', isEqualTo: flat)
          //.where('wing', isEqualTo: wing)
          //.where('flatNo', isEqualTo: flatNo)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

// Updating the status of child Approval
  Future<void> updateChildApprovalStatus(
      String society, String docId, bool status) async {
    try {
      if (status) {
        return _firestore
            .collection(society)
            .doc('childApprovals')
            .collection('ChildApproval')
            .doc(docId)
            .update({'status': 'Approved'});
      } else {
        return _firestore
            .collection(society)
            .doc('childApprovals')
            .collection('ChildApproval')
            .doc(docId)
            .update({'status': 'Rejected'});
      }
    } catch (e) {
      print(e.toString());
    }
    return;
  }

  // Fetch All Daily Helper in give flat
  Stream<QuerySnapshot> getAllDailyHelperForGivenFlat(
    String society,
    Map<String, String> flat,
    //String wing,
  ) {
    try {
      return _firestore
          .collection(society)
          .doc('dailyHelpers')
          .collection('Daily Helper')
          .where('worksAt', arrayContains: flat)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Get All helpers categorywise
  Stream<QuerySnapshot> getAllDailyHelperCategory(
      String society, String category) {
    try {
      if (category == "") {
        return _firestore
            .collection(society)
            .doc('dailyHelpers')
            .collection('Daily Helper')
            .snapshots();
      } else {
        return _firestore
            .collection(society)
            .doc('dailyHelpers')
            .collection('Daily Helper')
            .where('purpose', isEqualTo: category)
            .snapshots();
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Add a daily helper - Security
  Future<void> addDailyHelper(
      String society,
      String name,
      String phoneNum,
      List<Map<String, String>> worksAt,
      String imageUrl,
      String purpose,
      int code) async {
    try {
      await _firestore
          .collection(society)
          .doc('dailyHelpers')
          .collection('Daily Helper')
          .add({
        'name': name,
        'phoneNum': phoneNum,
        'worksAt': worksAt,
        'imageUrl': imageUrl,
        'purpose': purpose,
        'code': code
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Add a user in daily Visitor array - Resident
  Future<void> addDailyHelperForGivenFlat(
      String society, String id, Map<dynamic, dynamic> flat) async {
    try {
      await _firestore
          .collection(society)
          .doc('dailyHelpers')
          .collection('Daily Helper')
          .doc(id)
          .update({
        'worksAt': FieldValue.arrayUnion([flat])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Log daily helper visit
  Future<void> logDailyHelperVisit(
      String society, String docId, String activity) async {
    try {
      await _firestore
          .collection(society)
          .doc('dailyHelpers')
          .collection('Daily Helper')
          .doc(docId)
          .collection('Log')
          .add({'activity': activity, 'timestamp': DateTime.now()});
    } catch (e) {
      print(e.toString());
    }
  }

  // Get daily visitor log
  Stream<QuerySnapshot> getDailyVisitorLog(String society, String docId) {
    try {
      return _firestore
          .collection(society)
          .doc('dailyHelpers')
          .collection('Daily Helper')
          .doc(docId)
          .collection('Log')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Visitor approval - Security
  Future<void> sendApproval(
    String society,
    String name,
    String phoneNum,
    String imageUrl,
    String purpose,
    Map<String, String> flat,
    //String wing, String flatNo,
  ) async {
    try {
      await _firestore
          .collection(society)
          .doc('visitorApproval')
          .collection('Visitor Approval')
          .add({
        'name': name,
        'phoneNum': phoneNum,
        'flat': flat,
        //'flatNo': flatNo,
        'imageUrl': imageUrl,
        'purpose': purpose,
        //'wing': wing,
        'status': 'Pending',
        'entryTime': DateTime.now(),
        'exitTime': null
      });

      // Send notification to every person of that flat
      _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('flat', isEqualTo: flat)
          //.where('wing', isEqualTo: wing)
          //.where('flatNo', isEqualTo: flatNo)
          .get()
          .then((qs) {
        qs.docs.forEach((doc) {
          sendNotification(doc['token'], 'New Visitor Approval',
              'You have a new approval for visitor: $name');
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> markVisitorExit(String society, String docId) async {
    try {
      await _firestore
          .collection(society)
          .doc('visitorApproval')
          .collection('Visitor Approval')
          .doc(docId)
          .update({'exitTime': DateTime.now()});
    } catch (e) {
      print(e.toString());
    }
  }

  // Get recent visitor approval - Security
  Stream<QuerySnapshot> getRecentVisitorApproval(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('visitorApproval')
          .collection('Visitor Approval')
          .where('entryTime',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(Duration(days: 1)))
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Get past visitor approval - Security
  Stream<QuerySnapshot> getPastVisitorApproval(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('visitorApproval')
          .collection('Visitor Approval')
          .orderBy('entryTime', descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Get all pending visitor for specific flat
  Stream<QuerySnapshot> getAllPendingVisitorForGivenFlat(
    String society,
    Map<String, String> flat,
    //String wing,
  ) {
    try {
      return _firestore
          .collection(society)
          .doc('visitorApproval')
          .collection('Visitor Approval')
          .where('flat', isEqualTo: flat)
          //.where('wing', isEqualTo: wing.toUpperCase())
          //.where('flatNo', isEqualTo: flatNo)
          .where('status', isEqualTo: "Pending")
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Get All visitor log for specific flat
  Stream<QuerySnapshot> getAllVisitorForGivenFlat(
    String society,
    Map<String, String> flat,
    //String wing,
  ) {
    try {
      return _firestore
          .collection(society)
          .doc('visitorApproval')
          .collection('Visitor Approval')
          .where('flat', isEqualTo: flat)
          //.where('wing', isEqualTo: wing.toUpperCase())
          //.where('flatNo', isEqualTo: flatNo)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Get today's visitor for specific flat
  Stream<QuerySnapshot> getTodaysVisitorForGivenFlat(
    String society,
    Map<String, String> flat,
    //String wing,
  ) {
    try {
      return _firestore
          .collection(society)
          .doc('visitorApproval')
          .collection('Visitor Approval')
          .where('flat', isEqualTo: flat)
          //.where('wing', isEqualTo: wing.toUpperCase())
          //.where('flatNo', isEqualTo: flatNo)
          .where('entryTime',
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(Duration(days: 1)))
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Update the visitor approval
  Future<void> updateVisitorApproval(
      String society, String docId, bool status) {
    try {
      if (status) {
        _firestore
            .collection(society)
            .doc('visitorApproval')
            .collection('Visitor Approval')
            .doc(docId)
            .update({'status': 'Approved'});
      } else {
        _firestore
            .collection(society)
            .doc('visitorApproval')
            .collection('Visitor Approval')
            .doc(docId)
            .update({'status': 'Rejected'});
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Add the preApproval entry
  Future<void> addPreApprovalEntry(
      String society,
      String visName,
      String visPhoneNo,
      String vehicleNo,
      Map<dynamic, dynamic> flat,
      //String flatNo,
      //String wing,
      String code,
      String purpose,
      String imageUrl) async {
    try {
      await _firestore
          .collection(society)
          .doc('PreApprovals')
          .collection('preApproval')
          .add({
        'name': visName,
        'phoneNum': visPhoneNo,
        'vehicleNo': vehicleNo,
        'flat': flat,
        //'flatNo': flatNo,
        //'wing': wing,
        'generatedToken': code,
        'purpose': purpose,
        'postedOn': DateTime.now(),
        'status': "Pending",
        'entryTime': null,
        'exitTime': null,
        'imageUrl': imageUrl
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Get all preApprovals - Security
  Stream<void> getAllPreApprovals(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('PreApprovals')
          .collection('preApproval')
          .orderBy('postedOn', descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Get All pending preApproval for give flat and wing
  Stream<void> getAllPendingPreApprovalForGivenFlat(
    String society,
    Map<String, String> flat,
    //String wing,
  ) {
    try {
      return _firestore
          .collection(society)
          .doc('PreApprovals')
          .collection('preApproval')
          .where('flat', isEqualTo: flat)
          //.where('flatNo', isEqualTo: flatNo)
          //.where('wing', isEqualTo: wing)
          .where('status', isEqualTo: "Pending")
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Get all approved preapproval for given flat
  Stream<void> getAllApprovedPreApprovalForGivenFlat(
    String society,
    Map<String, String> flat,
    //String wing,
  ) {
    try {
      return _firestore
          .collection(society)
          .doc('PreApprovals')
          .collection('preApproval')
          .where('flat', isEqualTo: flat)
          //.where('flatNo', isEqualTo: flatNo)
          //.where('wing', isEqualTo: wing)
          .where('status', isEqualTo: "Approved")
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Update preApproval on given status
  Future<void> updatePendingApproval(
      String society, String docId, bool status) async {
    try {
      if (status) {
        await _firestore
            .collection(society)
            .doc('PreApprovals')
            .collection('preApproval')
            .doc(docId)
            .update({'status': "Approve"});
      } else {
        await _firestore
            .collection(society)
            .doc('PreApprovals')
            .collection('preApproval')
            .doc(docId)
            .update({'status': "Rejected", "entryTime": DateTime.now()});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Add entry time and exit time for pre approval
  Future<void> logPreApproval(
      String society, String docId, String parameter) async {
    try {
      await _firestore
          .collection(society)
          .doc('PreApprovals')
          .collection('preApproval')
          .doc(docId)
          .update({parameter: DateTime.now(), 'status': 'Approved'});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<QueryDocumentSnapshot> verifyByCode(String society, int code) async {
    try {
      QuerySnapshot qs;
      qs = await _firestore
          .collection(society)
          .doc('dailyHelpers')
          .collection('Daily Helper')
          .where('code', isEqualTo: code)
          .get();
      if (qs.size > 0) return qs.docs[0];
      qs = await _firestore
          .collection(society)
          .doc('PreApprovals')
          .collection('preApproval')
          .where('generatedToken', isEqualTo: code.toString())
          .get();
      if (qs.size > 0) return qs.docs[0];
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<QuerySnapshot> getUserDetailsBasedOnFlatNumber(
      String society, Map<dynamic, dynamic> flatNumber) async {
    try {
      //print(flatNumber);
      return await _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('flat', isEqualTo: flatNumber)
          .where('status', isEqualTo: "accepted")
          .get();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<QuerySnapshot> streamOfUserBasedOnFlatNumber(
      String society, Map<String, String> flatNumber) {
    try {
      //print(flatNumber);
      return _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('flat', isEqualTo: flatNumber)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<QuerySnapshot> getSecurityGuardsOfSociety(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('role', isEqualTo: "Security Guard")
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<bool> reApplication(
    String society,
    String uid,
    Map<String, String> newSocietyValue,
    String newRole,
  ) async {
    Globals g = Globals();
    //print("Databse.dart $newRole");
    try {
      if (DeepCollectionEquality().equals(g.flat, newSocietyValue)) {
        await _firestore
            .collection(g.society)
            .doc('users')
            .collection('User')
            .doc(g.uid)
            .update({
          "status": "pending",
          "homeRole": newRole,
        });
        return true;
      } else {
        await _firestore
            .collection(g.society)
            .doc('users')
            .collection('User')
            .doc(g.uid)
            .update({
          "status": "pending",
          "flat": newSocietyValue,
          "homeRole": newRole,
        });
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Stream<QuerySnapshot> getNumberOfPendingUsersForSociety(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('status', isEqualTo: 'pending')
          .snapshots();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> isOwnerPresent(
      String society, Map<String, String> flatNumber) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('flat', isEqualTo: flatNumber)
          .where('status', isEqualTo: "accepted")
          .get();
      if (snapshot.docs.length == 0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> updateStatus(String society, String email, String status) async {
    try {
      await _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('email', isEqualTo: email)
          .get()
          .then((val) {
        val.docs.forEach((doc) {
          doc.reference.update({"status": status});
        });
      });
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> uploadSupportComplaintQuey(
    String title,
    String description,
    List<String> images,
    String time,
    String uid,
    String society,
  ) async {
    try {
      await _firestore.collection("Support and Feedbac").doc(time).set({
        'title': title,
        'description': description,
        'images': images,
        'userId': uid,
        'society': society,
      });
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> isAcceptedParticularHomeRoleForFlatPresent(String society,
      Map<String, String> flat, String homeRoleToBeFound) async {
    try {
      QuerySnapshot userOfParticularFlat = await _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('flat', isEqualTo: flat)
          .where('status', isEqualTo: "accepted")
          .where('homeRole', isEqualTo: homeRoleToBeFound)
          .get();
      print(userOfParticularFlat.docs);
      if (userOfParticularFlat.docs.length >= 1) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Stream<QuerySnapshot> getStreamOfRoleOfParticularUser(
    String society,
    Map<String, String> flat,
    String roleToCheck,
  ) {
    try {
      return _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('flat', isEqualTo: flat)
          .where('homeRole', isEqualTo: roleToCheck)
          .where('status', isEqualTo: "accepted")
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<QuerySnapshot> streamOfSecurityGuardsOfSociety(String society) {
    try {
      return _firestore
          .collection(society)
          .doc('users')
          .collection('User')
          .where('role', isEqualTo: "Security Guard")
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Stream<DocumentSnapshot> streamOfAParticularComplaintFromSociety(
      String society, String complaintId) {
    try {
      return _firestore
          .collection(society)
          .doc('complaints')
          .collection('Complaint')
          .doc(complaintId)
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<bool> updateProgressOfTheComplaint(
      String society, String complaintId, List progress) async {
    try {
      await _firestore
          .collection(society)
          .doc("complaints")
          .collection("Complaint")
          .doc(complaintId)
          .update({"progress": progress});
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
