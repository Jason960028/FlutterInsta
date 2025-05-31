import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:insta_clone/utils/simple_snackbar.dart';

class FirebaseAuthState extends ChangeNotifier{
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.signOut;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _firebaseUser;
  FirebaseAuthState() { // ✅ 생성자에서 인증 상태 변경 감시 시작
    watchAuthChange();
  }

  void watchAuthChange() {
    _firebaseAuth.authStateChanges().listen((User? user) { // ✅ User? 타입 명시
      if (user == null) {
        _firebaseUser = null;
        _firebaseAuthStatus = FirebaseAuthStatus.signOut;
      } else {
        _firebaseUser = user;
        _firebaseAuthStatus = FirebaseAuthStatus.signIn;
      }
      print("Auth state changed: $_firebaseAuthStatus, User: ${_firebaseUser?.uid}");
      notifyListeners(); // ✅ 여기서 상태 변경 알림
    });
  }

  Future<void> registerUser({required String email, required String password}) async { // ✅ async 추가
    _firebaseAuthStatus = FirebaseAuthStatus.progress;
    notifyListeners();
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      // authStateChanges 리스너가 signIn 상태로 변경하고 notifyListeners()를 호출할 것입니다.
    } on FirebaseAuthException catch (e) {
      print('Registration Error: ${e.message}');
      _firebaseAuthStatus = FirebaseAuthStatus.signOut; // 오류 시 로그아웃 상태로 (또는 오류 상태 별도 정의)
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async { // ✅ async 추가
    _firebaseAuthStatus = FirebaseAuthStatus.progress;
    notifyListeners();
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      // authStateChanges 리스너가 signIn 상태로 변경하고 notifyListeners()를 호출할 것입니다.
    } on FirebaseAuthException catch (e) {
      print('Login Error: ${e.message} (Code: ${e.code})');
      // 예: 잘못된 비밀번호, 사용자를 찾을 수 없음 등
      // 여기에 사용자에게 오류를 알리는 로직 추가 가능 (예: SnackBar)
      _firebaseAuthStatus = FirebaseAuthStatus.signOut; // 오류 시 로그아웃 상태로
      notifyListeners();
    }
  }

  Future<void> signOut() async { // ✅ async 추가
    // _firebaseAuthStatus = FirebaseAuthStatus.signOut; // 스트림 리스너가 처리하도록 변경
    // if (_firebaseUser != null) {
    //   _firebaseUser = null;
    // }
    await _firebaseAuth.signOut(); // ✅ await 추가
    // authStateChanges 리스너가 signOut 상태로 변경하고 notifyListeners()를 호출할 것입니다.
    // notifyListeners(); // 스트림 리스너에서 호출되므로 여기서 중복 호출 불필요
  }

  // changeFirebaseAuthStatus 메서드는 authStateChanges에 의해 자동으로 상태가 관리되므로,
  // 특별한 경우가 아니라면 직접 호출할 필요가 줄어듭니다.
  // 만약 수동으로 상태를 변경해야 한다면, 명확한 목적을 가지고 사용해야 합니다.
  // 아래는 기존 메서드 시그니처를 유지한 수정 예시이나, 사용에 주의가 필요합니다.
  void manualSetFirebaseAuthStatus(FirebaseAuthStatus status) {
    _firebaseAuthStatus = status;
    if (status == FirebaseAuthStatus.signOut) {
      _firebaseUser = null; // 로그아웃 시 사용자 정보도 초기화
    } else if (status == FirebaseAuthStatus.signIn) {
      // 이 경우, _firebaseUser가 외부에서 올바르게 설정되었다는 가정이 필요합니다.
      // 또는 _firebaseAuth.currentUser를 다시 확인합니다.
      _firebaseUser = _firebaseAuth.currentUser;
      if (_firebaseUser == null) { // currentUser가 없는데 signIn 상태로 만들려는 경우
        _firebaseAuthStatus = FirebaseAuthStatus.signOut; // 안전하게 signOut으로 변경
      }
    }
    notifyListeners();
  }

  void changeFirebaseAuthStatus([FirebaseAuthStatus? firebaseAuthStatus]){
    if(firebaseAuthStatus != null){
      _firebaseAuthStatus = firebaseAuthStatus;
    }else{
      if(_firebaseUser != null){
        _firebaseAuthStatus = FirebaseAuthStatus.signOut;
      } else {
        _firebaseAuthStatus = FirebaseAuthStatus.signOut;
      }
    }
    notifyListeners();
  }

  Future<void> loginWithFacebook(BuildContext context) async { // Future<void>로 변경
    _firebaseAuthStatus = FirebaseAuthStatus.progress;
    notifyListeners();

    try {
      // 1. flutter_facebook_auth를 사용하여 Facebook 로그인 시도
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'], // 필요한 권한 요청
      );

      // 2. Facebook 로그인 결과 확인
      switch (result.status) {
        case LoginStatus.success:
        // Facebook 로그인 성공 시 AccessToken 가져오기
          final AccessToken accessToken = result.accessToken!;
          print('Facebook AccessToken: ${accessToken.tokenString}');
          // Firebase에 Facebook 자격 증명으로 로그인하는 내부 메서드 호출
          await _signInWithFacebookCredential(context, accessToken.tokenString); // await 추가
          break;
        case LoginStatus.cancelled:
          simpleSnackbar(context, '페이스북 로그인이 취소되었습니다.');
          _firebaseAuthStatus = FirebaseAuthStatus.signOut;
          notifyListeners();
          break;
        case LoginStatus.failed:
          simpleSnackbar(context, '페이스북 로그인에 실패했습니다: ${result.message ?? "알 수 없는 오류"}');
          _firebaseAuthStatus = FirebaseAuthStatus.signOut;
          notifyListeners();
          break;
        case LoginStatus.operationInProgress:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    } on FirebaseAuthException catch (e) { // Firebase 관련 오류 처리
      simpleSnackbar(context, 'Firebase 오류: ${e.message ?? "알 수 없는 오류"}');
      _firebaseAuthStatus = FirebaseAuthStatus.signOut;
      notifyListeners();
    } catch (e) { // 기타 예외 처리
      simpleSnackbar(context, '오류가 발생했습니다: $e');
      _firebaseAuthStatus = FirebaseAuthStatus.signOut;
      notifyListeners();
    }
  }

  // 👇 Facebook 자격 증명으로 Firebase에 로그인하는 내부 헬퍼 메서드
  Future<void> _signInWithFacebookCredential(BuildContext context, String token) async {
    try {
      // Facebook 액세스 토큰으로 Firebase용 OAuthCredential 생성
      final OAuthCredential credential = FacebookAuthProvider.credential(token); // ✅ 최신 문법

      // 생성된 credential로 Firebase에 로그인
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential); // ✅ 최신 문법 (AuthResult -> UserCredential)
      final User? user = userCredential.user; // ✅ 최신 문법 (FirebaseUser -> User)

      if (user == null) {
        simpleSnackbar(context, 'Firebase에 페이스북 계정으로 로그인하는데 실패했습니다.');
        _firebaseAuthStatus = FirebaseAuthStatus.signOut;
        // _firebaseUser는 authStateChanges 리스너에 의해 null로 설정됨
      } else {
        // _firebaseUser = user; // authStateChanges 리스너가 처리
        // _firebaseAuthStatus = FirebaseAuthStatus.signIn; // authStateChanges 리스너가 처리
        print('Successfully signed in with Facebook: ${user.displayName}');
      }
      // notifyListeners(); // authStateChanges 리스너가 호출하므로 여기서 중복 호출 불필요
    } on FirebaseAuthException catch (e) {
      // Firebase 로그인 중 오류 (예: account-exists-with-different-credential)
      print('Firebase signInWithCredential error: ${e.message} (Code: ${e.code})');
      simpleSnackbar(context, '로그인 오류');
      _firebaseAuthStatus = FirebaseAuthStatus.signOut;
      notifyListeners(); // 오류 발생 시 UI 업데이트를 위해 호출
    } catch (e) {
      simpleSnackbar(context, '알 수 없는 오류가 발생했습니다.');
      _firebaseAuthStatus = FirebaseAuthStatus.signOut;
      notifyListeners();
    }
  }

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;
  User? get currentUser => _firebaseUser;
}

enum FirebaseAuthStatus{
  signOut,
  progress,
  signIn
}