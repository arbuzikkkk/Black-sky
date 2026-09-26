import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:black_sky/core/constants/game_constants.dart';
import 'package:black_sky/domain/entities/player_entity.dart';

/// Firestore (de)serialization for [PlayerProfile]. Kept separate from the
/// domain entity so Firestore field-name churn never touches game logic.
class PlayerModel {
  static PlayerProfile fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      return PlayerProfile.newAccount(uid: doc.id, displayName: 'Commander');
    }
    return PlayerProfile(
      uid: doc.id,
      displayName: data['displayName'] as String? ?? 'Commander',
      level: data['level'] as int? ?? 1,
      xp: data['xp'] as int? ?? 0,
      favoriteFaction: Faction.values.firstWhere(
        (f) => f.name == (data['favoriteFaction'] as String? ?? Faction.usa.name),
        orElse: () => Faction.usa,
      ),
      wins: data['wins'] as int? ?? 0,
      losses: data['losses'] as int? ?? 0,
      kills: data['kills'] as int? ?? 0,
      deaths: data['deaths'] as int? ?? 0,
      credits: data['credits'] as int? ?? 0,
      gold: data['gold'] as int? ?? 0,
    );
  }

  static Map<String, dynamic> toFirestore(PlayerProfile profile) {
    return {
      'displayName': profile.displayName,
      'level': profile.level,
      'xp': profile.xp,
      'favoriteFaction': profile.favoriteFaction.name,
      'wins': profile.wins,
      'losses': profile.losses,
      'kills': profile.kills,
      'deaths': profile.deaths,
      'credits': profile.credits,
      'gold': profile.gold,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
