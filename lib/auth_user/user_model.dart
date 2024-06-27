import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  String? _userName;
  String? _userEmail;
  String? _phoneNumber; // New property for user phone number
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchCurrentUser(user.uid);
      } else {
        _userName = null;
        _userEmail = null;
        _phoneNumber = null; // Reset phone number when user signs out
        notifyListeners();
      }
    });
  }

  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get phoneNumber => _phoneNumber; // Getter for user phone number

  Future<void> _fetchCurrentUser(String userId) async {
    final docSnapshot = await _firestore.collection('users').doc(userId).get();
    if (docSnapshot.exists) {
      _userName = docSnapshot.data()?['fullName'];
      _userEmail = docSnapshot.data()?['email'];
      _phoneNumber = docSnapshot.data()?['phoneNumber']; // Get user phone number
      notifyListeners();
    }
  }

  Future<void> updateUsername(String newUsername) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fullName': newUsername,
      });
      _userName = newUsername;
      notifyListeners();
    }
  }

  Future<void> updateEmail(String newEmail) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await user.updateEmail(newEmail);
      await _firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
      });
      _userEmail = newEmail;
      notifyListeners();
    }
  }

  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'phoneNumber': newPhoneNumber,
      });
      _phoneNumber = newPhoneNumber;
      notifyListeners();
    }
  }
}
