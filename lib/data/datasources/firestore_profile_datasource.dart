import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:black_sky/data/models/player_model.dart';
import 'package:black_sky/domain/entities/player_entity.dart';

class FirestoreProfileDataSource {
  FirestoreProfileDataSource(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _players => _firestore.collection('players');

  Future<PlayerProfile> fetchOrCreate({required String uid, required String displayName}) async {
    final doc = await _players.doc(uid).get();
    if (doc.exists) {
      return PlayerModel.fromFirestore(doc);
    }
    final fresh = PlayerProfile.newAccount(uid: uid, displayName: displayName);
    await _players.doc(uid).set(PlayerModel.toFirestore(fresh));
    return fresh;
  }

  Future<void> save(PlayerProfile profile) {
    return _players.doc(profile.uid).set(PlayerModel.toFirestore(profile), SetOptions(merge: true));
  }

  Stream<PlayerProfile?> watch(String uid) {
    return _players.doc(uid).snapshots().map((doc) => doc.exists ? PlayerModel.fromFirestore(doc) : null);
  }
}
