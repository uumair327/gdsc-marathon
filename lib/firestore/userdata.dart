import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";


void setUser(email) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;

    //Register
    db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get().then((DocumentSnapshot doc){
      if(!doc.exists){
        db.collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({"email":email, "currentCheckpoint": 0, "checkpointTimes":[], "distance":0, "calories":0})
            .onError((e, _) => print("Error writing document: $e"));
      }
    });
  } catch (e) {
    print('Error setting user: $e');
  }
}

void updateCheckpoint(newCheckpoint) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({"currentCheckpoint": newCheckpoint}, SetOptions(merge: true))
        .onError((e, _) => print("Error writing document: $e"));

  } catch (e) {
    print('Error setting user: $e');
  }
}
