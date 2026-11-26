import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/app/services/auth_service.dart';
import 'package:moms_list/app/services/firebase_auth_service.dart';

class _MockAuth extends Mock implements FirebaseAuth;

class _MockGoogle extends Mock implements GoogleSignIn;

class _MockGoogleAccount extends Mock implements GoogleSignInAccount;

class _MockUser extends Mock implements User;

class _MockCredential extends Mock implements UserCredential;

void main() {
  late _MockAuth auth;
  late _MockGoogle google;

  setUpAll(() {
    registerFallbackValue(GoogleAuthProvider());
    registerFallbackValue(GoogleAuthProvider.credential(idToken: 'x'));
  });

  setUp(() {
    auth = _MockAuth();
    google = _MockGoogle();
    final credential = _MockCredential();
    when(() => google.initialize(clientId: any(named: 'clientId')))
        .thenAnswer((_) async {});
    when(() => google.signOut()).thenAnswer((_) async {});
    when(() => auth.signOut()).thenAnswer((_) async {});
    when(() => auth.signInWithPopup(any())).thenAnswer((_) async => credential);
    when(() => auth.signInWithCredential(any()))
        .thenAnswer((_) async => credential);
  });

  FirebaseAuthService service({bool isWeb = false}) => FirebaseAuthService(
    auth: auth,
    google: google,
    googleClientId: 'ios-client',
    isWeb: isWeb,
  );

  group('watchUser', () {
    test('maps Firebase users', () async {
      final user = _MockUser();
      when(() => user.uid).thenReturn('mom');
      when(() => user.displayName).thenReturn('Mom');
      when(() => user.email).thenReturn('mom@example.com');
      when(() => auth.authStateChanges())
          .thenAnswer((_) => Stream.fromIterable([null, user]));

      expect(await service().watchUser().toList(), const [
        null,
        AuthUser(id: 'mom', displayName: 'Mom', email: 'mom@example.com'),
      ]);
    });
  });

  group('signInWithGoogle', () {
    test('uses the native Google sheet on phones', () async {
      final account = _MockGoogleAccount();
      when(() => account.authentication)
          .thenReturn(const GoogleSignInAuthentication(idToken: 'id-token'));
      when(() => google.authenticate()).thenAnswer((_) async => account);

      expect(await service().signInWithGoogle(), AuthOutcome.completed);

      verify(() => google.initialize(clientId: 'ios-client')).called(1);
      final signedInWith =
          verify(() => auth.signInWithCredential(captureAny())).captured.single
              as AuthCredential;
      expect(signedInWith.providerId, 'google.com');
    });

    test('uses a popup on web', () async {
      expect(
        await service(isWeb: true).signInWithGoogle(),
        AuthOutcome.completed,
      );

      verify(() => auth.signInWithPopup(any(that: isA<GoogleAuthProvider>())));
      verifyNever(() => google.authenticate());
    });

    test('reports closing the Google sheet as canceled', () async {
      when(() => google.authenticate()).thenThrow(
        const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
      );

      expect(await service().signInWithGoogle(), AuthOutcome.canceled);
    });

    test('wraps other Google errors', () async {
      when(() => google.authenticate()).thenThrow(
        const GoogleSignInException(
          code: GoogleSignInExceptionCode.clientConfigurationError,
        ),
      );

      await expectLater(
        service().signInWithGoogle(),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('reports a closed popup as canceled and wraps failures', () async {
      when(() => auth.signInWithPopup(any()))
          .thenThrow(FirebaseAuthException(code: 'popup-closed-by-user'));
      expect(
        await service(isWeb: true).signInWithGoogle(),
        AuthOutcome.canceled,
      );

      when(() => auth.signInWithPopup(any()))
          .thenThrow(FirebaseAuthException(code: 'network-request-failed'));
      await expectLater(
        service(isWeb: true).signInWithGoogle(),
        throwsA(isA<AuthFailure>()),
      );
    });
  });

  group('signOut', () {
    test('signs out of Firebase and the Google sheet', () async {
      await service().signOut();

      verify(() => auth.signOut());
      verify(() => google.signOut());
    });

    test('skips the Google sheet on web', () async {
      await service(isWeb: true).signOut();

      verify(() => auth.signOut());
      verifyNever(() => google.signOut());
    });
  });
}
