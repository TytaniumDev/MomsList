import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moms_list/auth/auth.dart';

class _MockAuth extends Mock implements FirebaseAuth;

class _MockGoogle extends Mock implements GoogleSignIn;

class _MockGoogleAccount extends Mock implements GoogleSignInAccount;

class _MockUser extends Mock implements User;

class _MockUserInfo extends Mock implements UserInfo;

class _MockCredential extends Mock implements UserCredential;

void main() {
  late _MockAuth auth;
  late _MockGoogle google;

  setUpAll(() {
    registerFallbackValue(GoogleAuthProvider());
    registerFallbackValue(AppleAuthProvider());
    registerFallbackValue(GoogleAuthProvider.credential(idToken: 'x'));
  });

  setUp(() {
    auth = _MockAuth();
    google = _MockGoogle();
    final credential = _MockCredential();
    when(
      () => google.initialize(
        clientId: any(named: 'clientId'),
        serverClientId: any(named: 'serverClientId'),
      ),
    ).thenAnswer((_) async {});
    when(() => google.signOut()).thenAnswer((_) async {});
    when(() => auth.signOut()).thenAnswer((_) async {});
    when(() => auth.signInWithPopup(any())).thenAnswer((_) async => credential);
    when(() => auth.signInWithProvider(any()))
        .thenAnswer((_) async => credential);
    when(() => auth.signInWithCredential(any()))
        .thenAnswer((_) async => credential);
  });

  FirebaseAuthRepository repository({bool isWeb = false}) =>
      FirebaseAuthRepository(
        auth: auth,
        google: google,
        googleClientId: 'ios-client',
        googleServerClientId: 'web-client',
        isWeb: isWeb,
      );

  _MockUser userWith(String providerId) {
    final user = _MockUser();
    final info = _MockUserInfo();
    when(() => info.providerId).thenReturn(providerId);
    when(() => user.uid).thenReturn('mom');
    when(() => user.displayName).thenReturn('Mom');
    when(() => user.email).thenReturn('mom@example.com');
    when(() => user.providerData).thenReturn([info]);
    return user;
  }

  group('watchUser', () {
    test('maps Firebase users, with how they signed in', () async {
      when(() => auth.authStateChanges()).thenAnswer(
        (_) => Stream.fromIterable([
          null,
          userWith('apple.com'),
          userWith('google.com'),
          userWith('password'),
        ]),
      );

      expect(await repository().watchUser().toList(), const [
        null,
        AuthUser(
          id: 'mom',
          displayName: 'Mom',
          email: 'mom@example.com',
          method: SignInMethod.apple,
        ),
        AuthUser(
          id: 'mom',
          displayName: 'Mom',
          email: 'mom@example.com',
          method: SignInMethod.google,
        ),
        AuthUser(id: 'mom', displayName: 'Mom', email: 'mom@example.com'),
      ]);
    });
  });

  group('signInWithApple', () {
    test('uses the provider flow on phones and a popup on web', () async {
      expect(await repository().signInWithApple(), AuthOutcome.completed);
      verify(
        () => auth.signInWithProvider(any(that: isA<AppleAuthProvider>())),
      );

      expect(
        await repository(isWeb: true).signInWithApple(),
        AuthOutcome.completed,
      );
      verify(() => auth.signInWithPopup(any(that: isA<AppleAuthProvider>())));
    });

    test('reports a closed sheet as canceled and wraps failures', () async {
      when(() => auth.signInWithProvider(any()))
          .thenThrow(FirebaseAuthException(code: 'web-context-canceled'));
      expect(await repository().signInWithApple(), AuthOutcome.canceled);

      when(() => auth.signInWithProvider(any()))
          .thenThrow(FirebaseAuthException(code: 'network-request-failed'));
      await expectLater(
        repository().signInWithApple(),
        throwsA(isA<AuthFailure>()),
      );
    });
  });

  group('signInWithGoogle', () {
    test('uses the native Google sheet on phones', () async {
      final account = _MockGoogleAccount();
      when(() => account.authentication)
          .thenReturn(const GoogleSignInAuthentication(idToken: 'id-token'));
      when(() => google.authenticate()).thenAnswer((_) async => account);

      expect(await repository().signInWithGoogle(), AuthOutcome.completed);

      verify(
        () => google.initialize(
          clientId: 'ios-client',
          serverClientId: 'web-client',
        ),
      ).called(1);
      final signedInWith =
          verify(() => auth.signInWithCredential(captureAny())).captured.single
              as AuthCredential;
      expect(signedInWith.providerId, 'google.com');
    });

    test('uses a popup on web', () async {
      expect(
        await repository(isWeb: true).signInWithGoogle(),
        AuthOutcome.completed,
      );

      verify(() => auth.signInWithPopup(any(that: isA<GoogleAuthProvider>())));
      verifyNever(() => google.authenticate());
    });

    test('reports closing the Google sheet as canceled', () async {
      when(() => google.authenticate()).thenThrow(
        const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
      );

      expect(await repository().signInWithGoogle(), AuthOutcome.canceled);
    });

    test('wraps other Google errors', () async {
      when(() => google.authenticate()).thenThrow(
        const GoogleSignInException(
          code: GoogleSignInExceptionCode.clientConfigurationError,
        ),
      );

      await expectLater(
        repository().signInWithGoogle(),
        throwsA(isA<AuthFailure>()),
      );
    });
  });

  group('signOut', () {
    test('signs out of Firebase and the Google sheet', () async {
      await repository().signOut();

      verify(() => auth.signOut());
      verify(() => google.signOut());
    });

    test('skips the Google sheet on web', () async {
      await repository(isWeb: true).signOut();

      verify(() => auth.signOut());
      verifyNever(() => google.signOut());
    });
  });
}
