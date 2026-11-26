import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Tests run from the package root, where firebase.json points at this file.
  // The fake checks rules on document reads and writes, not on queries, so
  // these tests read single documents.
  final rules = File('firestore.rules').readAsStringSync();

  FakeFirebaseFirestore signedInAs(String? uid) => FakeFirebaseFirestore(
    securityRules: rules,
    authObject: Stream.value(uid == null ? null : {'uid': uid}),
  );

  group('firestore.rules', () {
    test('lets Mom read and write her own stores and items', () async {
      final firestore = signedInAs('mom');
      final mom = firestore.collection('users').doc('mom');

      await mom.collection('stores').doc('costco').set({'name': 'Costco'});
      await mom.collection('items').doc('milk').set({'name': 'Milk'});

      expect((await mom.collection('items').get()).docs, hasLength(1));
      await mom.collection('items').doc('milk').delete();
    });

    test("keeps other people out of Mom's list", () async {
      final firestore = signedInAs('someone-else');
      final mom = firestore.collection('users').doc('mom');

      await expectLater(
        mom.collection('items').doc('milk').set({'name': 'Milk'}),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        mom.collection('stores').doc('costco').get(),
        throwsA(isA<Exception>()),
      );
    });

    test('keeps signed-out visitors out', () async {
      final firestore = signedInAs(null);

      await expectLater(
        firestore
            .collection('users')
            .doc('mom')
            .collection('items')
            .doc('milk')
            .get(),
        throwsA(isA<Exception>()),
      );
    });

    test('denies everything outside users', () async {
      final firestore = signedInAs('mom');

      await expectLater(
        firestore.collection('other').doc('x').set({'a': 1}),
        throwsA(isA<Exception>()),
      );
    });
  });
}
