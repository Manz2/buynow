import 'package:flutter/cupertino.dart';
import 'package:buynow/src/login/login.controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  final LoginController controller;

  const LoginView({super.key, required this.controller});

  static const routeName = '/login';

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _showDialog(String title, String message) async {
    await showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.controller.model.mail,
        password: widget.controller.model.password,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      await _showDialog('Fehler', e.message ?? 'Login fehlgeschlagen');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.controller.model.mail,
        password: widget.controller.model.password,
      );

      final uid = FirebaseAuth.instance.currentUser!.uid;
      await widget.controller.createUserData(uid);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      await _showDialog('Fehler', e.message ?? 'Registrierung fehlgeschlagen');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Login')),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /*ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/images/login.png'),
                ),
                const SizedBox(height: 24),*/
                CupertinoTextField(
                  placeholder: 'E-Mail',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => widget.controller.model.mail = v,
                  padding: const EdgeInsets.all(16),
                ),
                const SizedBox(height: 16),

                CupertinoTextField(
                  placeholder: 'Passwort',
                  obscureText: true,
                  onChanged: (v) => widget.controller.model.password = v,
                  padding: const EdgeInsets.all(16),
                ),
                const SizedBox(height: 32),

                _isLoading
                    ? const CupertinoActivityIndicator()
                    : Column(
                        children: [
                          CupertinoButton.filled(
                            onPressed: _login,
                            child: const Text('Einloggen'),
                          ),
                          const SizedBox(height: 12),
                          CupertinoButton(
                            onPressed: _register,
                            child: const Text('Noch kein Konto? Registrieren'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
