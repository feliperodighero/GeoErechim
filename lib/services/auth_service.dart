import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Retorna o usuário logado atualmente (ou null se deslogado)
  User? get currentUser => _auth.currentUser;

  /// Retorna um stream contínuo das mudanças de estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Realiza o login com o Google Popup / Selecionador de Conta
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Abre o diálogo nativo do Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // O usuário fechou a janela de login sem selecionar uma conta
        return null;
      }

      // Obtém os detalhes da autenticação da requisição do painel
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Cria uma nova credencial usando o token recebido
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Entra no Firebase com a credencial do Google
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Erro no fluxo de Google Sign-In: $e');
      return null;
    }
  }

  /// Desliga o usuário do Firebase e do Google Sign-In localmente
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Erro ao tentar deslogar: $e');
    }
  }
}
