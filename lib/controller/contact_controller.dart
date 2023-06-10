import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasematerial/model/contact_model.dart';

class ContactController {
  final contactCollection = FirebaseFirestore.instance.collection('contact');

  final StreamController<List<DocumentSnapshot>> streamController =
    StreamController<List<DocumentSnapshot>>.broadcast();
  
  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future <void>addContact(ContactModel contactmodel) async {
    final contact = contactmodel.toMap();
    final DocumentReference docRef = await contactCollection.add(contact);
    final String docId = docRef.id;

    final ContactModel contactModel = ContactModel(
      id: docId,
      name: contactmodel.name,
      email: contactmodel.email,
      phone: contactmodel.phone,
      address: contactmodel.address
    );

    await docRef.update(contactModel.toMap());
  }

  Future getContact() async {
    final contact = await contactCollection.get();
    streamController.sink.add(contact.docs);
    return contact.docs;
  }

  Future deleteContact(String id) async {
    final contact = await contactCollection.doc(id).delete();
    return contact;
  }

  Future updateContact(ContactModel ctmodel) async {
    final ContactModel ctmodelUpdated = ContactModel(
      id: ctmodel.id,
      name: ctmodel.name, 
      phone: ctmodel.phone, 
      email: ctmodel.email, 
      address: ctmodel.address);

      return await contactCollection.doc(ctmodel.id).update(ctmodelUpdated.toMap());
  }
}