import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../pallete.dart';
import '../auth_widgets/widgets.dart';
import '../../providers/auth.dart';
import '../auth_screen/login-screen.dart';
import '../auth_widgets/circular-progress-indicator.dart';
import '../../models/http_exceptions.dart';

class CreateNewAccount extends StatelessWidget {
  static const routeName = '/ceate-new-account';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        BackgroundImage(image: 'assets/images/register_bg.png'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: AuthSignup(size: size),
        )
      ],
    );
  }
}

class AuthSignup extends StatefulWidget {
  const AuthSignup({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  _AuthSignupState createState() => _AuthSignupState();
}

class _AuthSignupState extends State<AuthSignup> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.Signup;

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
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email already exists';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'The password is too weak';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: widget.size.width * 0.1,
          ),
          Stack(
            children: [
              Center(
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: CircleAvatar(
                      radius: widget.size.width * 0.14,
                      backgroundColor: Colors.grey[400].withOpacity(
                        0.4,
                      ),
                      child: Icon(
                        FontAwesomeIcons.user,
                        color: kWhite,
                        size: widget.size.width * 0.1,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: widget.size.height * 0.08,
                left: widget.size.width * 0.56,
                child: Container(
                  height: widget.size.width * 0.1,
                  width: widget.size.width * 0.1,
                  decoration: BoxDecoration(
                    color: kBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: kWhite, width: 2),
                  ),
                  child: Icon(
                    FontAwesomeIcons.arrowUp,
                    color: kWhite,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: widget.size.width * 0.1,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextInputField(
                  icon: FontAwesomeIcons.user,
                  hint: 'Name',
                  inputType: TextInputType.name,
                  inputAction: TextInputAction.next,
                ),
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
                  inputAction: TextInputAction.next,
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
                PasswordInput(
                  icon: FontAwesomeIcons.lock,
                  hint: 'Confirm Password',
                  inputAction: TextInputAction.done,
                  validate: (value) {
                    if (value != _passwordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Passwords do not match!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                _isLoading
                    ? CircularProgIndicator()
                    : RoundedButton(
                        buttonName: 'Register',
                        onpress: () {
                          _submit();
                        },
                      ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: kBodyText,
                    ),
                    GestureDetector(
                      onTap: () {
                        _switchAuthMode();
                        Navigator.of(context).pushNamed('/');
                      },
                      child: Text(
                        'Login',
                        style: kBodyText.copyWith(
                            color: kBlue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
