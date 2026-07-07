import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:live_vitalist/storage/data/storage_solution.dart';
import 'package:live_vitalist/storage/domain/storage_handler.dart';
import 'package:path/path.dart' as p;

import 'package:live_vitalist/json_handler.dart';

final class FirebaseHandler implements IStorageHandler {
  // @override
  // late IStorageHandler? nextHandler;
  // FirebaseHandler(this.nextHandler);

  @override
  Future<bool> saveJson(String path, Map<String, dynamic> json) async {
    final fileName = p.basenameWithoutExtension(path);
    if (fileName.contains('_backup') || fileName == 'settings') return false;

    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final db = FirebaseDatabase.instance.ref();

    /* Just waits until it has internet connection and sends. 
       If there is no internet connection, it waits, no exceptions given. */
    await db
        .child('users/$uid/$path')
        .set(json); /* used `mapToListRecursive` to maintain order */

    return true;
  }

  @override
  Future<Map<String, dynamic>?> loadJson(String path) async {
    if (!StorageSolution.isFirebase) return null;

    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final db = FirebaseDatabase.instance.ref();

    final snapshot = await db.child('users/$uid/$path').get();

    if (snapshot.exists && snapshot.value != null) {
      return (JsonHandler.reverseMapToListRecursive(snapshot.value) as Map)
          .map<String, dynamic>((key, value) => MapEntry(key as String, value));
    }

    return null;
  }
}
