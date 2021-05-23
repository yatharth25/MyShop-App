import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../pallete.dart';
import '../auth_widgets/widgets.dart';
import '../auth_screen/create-new-account.dart';
import '../auth_screen/forgot-password.dart';
import '../../providers/auth.dart';
import '../../models/http_exceptions.dart';
import '../auth_widgets/circular-progress-indicator.dart';

enum AuthMode { Signup, Login }

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(
          image: 'assets/images/login_bg.jpg',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: AuthLogin(),
        )
      ],
    );
  }
}

class AuthLogin extends StatefulWidget {
  const AuthLogin({
    Key key,
  }) : super(key: key);

  @override
  _AuthLoginState createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured!'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Aunthentication failed';
      if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find the email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Password did not match';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not aunthenticate you. PLease try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Center(
            child: Text(
              'MyShop',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextInputField(
                icon: FontAwesomeIcons.envelope,
                hint: 'Email',
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                save: (value) {
                  _authData['email'] = value;
                },
                validate: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Invalid Email!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                  return null;
                },
              ),
              PasswordInput(
                icon: FontAwesomeIcons.lock,
                hint: 'Password',
                inputAction: TextInputAction.done,
                controller: _passwordController,
                save: (value) {
                  _authData['password'] = value;
                },
                validate: (value) {
                  if (value.isEmpty || value.length < 5) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Password is too short!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.of(context).pushNamed(ForgotPassword.routeName),
                },
                child: Text(
                  'Forgot Password',
                  style: kBodyText,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              _isLoading
                  ? CircularProgIndicator()
                  : RoundedButton(
                      buttonName: 'Login',
                      onpress: () {
                        _submit();
                      },
                    ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => {
            _switchAuthMode(),
            Navigator.of(context).pushNamed(CreateNewAccount.routeName),
          },
          child: Container(
            child: Text(
              'Create New Account',
              style: kBodyText,
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: kWhite))),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
