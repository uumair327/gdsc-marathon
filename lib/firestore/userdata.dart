import "dart:html";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

void setUser(email) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;

    //Register
    db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot doc) {
      if (!doc.exists) {
        db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).set({
          "email": email,
          "currentCheckpoint": 0,
          "checkpointTimes": [0],
          "distance": 0,
          "calories": 0
        }).onError((e, _) => print("Error writing document: $e"));
      }
    });
  } catch (e) {
    print('Error setting user: $e');
  }
}

void updateCheckpoint(newCheckpoint, stopwatch) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          if(data["currentCheckpoint"] == newCheckpoint - 1){
            if(data["checkpointTimes"].length - 1 == data["currentCheckpoint"]){
              db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).update({
                "currentCheckpoint": newCheckpoint,
                "checkpointTimes": FieldValue.arrayUnion([stopwatch]),
              }).onError((e, _) => print("Error writing document: $e"));
            }
          }
    });

  } catch (e) {
    print('Error setting user: $e');
  }
}
