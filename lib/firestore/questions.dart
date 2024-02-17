import "package:cloud_firestore/cloud_firestore.dart";


Future<List<dynamic>> fetchQuestions() async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final querySnapshot = await db.collection('questions').get();
    var questions = [];
    querySnapshot.docs.forEach((doc) {
      questions.add(doc.data());
    });
    return(questions);
  } catch (e) {
    print('Error fetching questions: $e');
    return([]);
  }
}

