import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'post_login_page.dart';

//TODO
//fix facebook login
//fix email does not exist pop up error
//login page blinks on app bootup

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final AccessToken result =
      (await FacebookAuth.instance.login()) as AccessToken;

  // Create a credential from the access token
  final facebookAuthCredential = FacebookAuthProvider.credential(result.token);

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance
      .signInWithCredential(facebookAuthCredential);
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class LoginSwitch extends StatelessWidget {
  const LoginSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return LoginPage();
        }
        return PostLoginPage();
      },
      stream: FirebaseAuth.instance.authStateChanges(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Spacer(),
          SignInButton(
            Buttons.Email,
            text: "Sign in with email",
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => ManualLogin()),
          ),
          SignInButton(
            Buttons.Google,
            text: "Sign in with Google",
            onPressed: signInWithGoogle,
          ),
          SignInButton(
            Buttons.Facebook,
            text: "Sign in with Facebook",
            onPressed: signInWithFacebook,
          ),
          Row(
            children: [
              Spacer(),
              Text("No account? No problem! "),
              GestureDetector(
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => SignupPage()),
                child: Text(
                  "Sign up here!",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              Spacer()
            ],
          ),
          Spacer()
        ],
      ),
    ));
  }
}

class ManualLogin extends StatelessWidget {
  ManualLogin({Key? key}) : super(key: key);

  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Login"),
      content: IntrinsicHeight(
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text("Cancel")),
        ElevatedButton(
            onPressed: () async {
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email.text, password: password.text);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("No user found for that email."),
                    action: SnackBarAction(
                        label: 'Sign up',
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => SignupPage())),
                  ));
                } else if (e.code == 'wrong-password') {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Wrong password provided for that user."),
                  ));
                }
              }
            },
            child: Text("Login")),
      ],
    );
  }
}

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Sign Up"),
      content: IntrinsicHeight(
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),
            SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: signInWithGoogle,
            ),
            SignInButton(
              Buttons.Facebook,
              text: "Sign up with Facebook",
              onPressed: signInWithFacebook,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text("Cancel")),
        ElevatedButton(
            onPressed: () async {
              try {
                UserCredential userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email.text, password: password.text);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("The password provided is too weak."),
                  ));
                } else if (e.code == 'email-already-in-use') {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("The account already exists for that email."),
                  ));
                }
              } catch (e) {
                print(e);
              }
            },
            child: Text("Sign Up")),
      ],
    );
  }
}
