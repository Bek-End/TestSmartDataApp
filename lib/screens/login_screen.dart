import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/bloc/login_check_bloc.dart';
import 'package:test_app/bloc/switch_screen_bloc.dart';
import 'package:test_app/elements/loading_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(16),
            child: StreamBuilder(
                stream: loginCheckBloc.subject.stream,
                initialData: loginCheckBloc.defaultLoginState,
                builder: (context, AsyncSnapshot<LoginCheckStates> snapshot) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: widget.emailController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            hintText: "Enter email",
                            errorText: (snapshot.data ==
                                    LoginCheckStates.WRONG_EMAIL_INPUT_STATE)
                                ? "Invalid Email"
                                : null),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: widget.confirmPasswordController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            hintText: "Enter password",
                            errorText: (snapshot.data ==
                                    LoginCheckStates.PASSWORDS_NOT_EQUAL_STATE)
                                ? "Passwords don't match"
                                : null),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: widget.passwordController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            hintText: "Enter password once again",
                            errorText: (snapshot.data ==
                                    LoginCheckStates.PASSWORDS_NOT_EQUAL_STATE)
                                ? "Passwords don't match"
                                : null),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          child: FlatButton(
                              color: Colors.orange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              onPressed: () => loginCheckBloc.checkCredentials(
                                  LoginCheckEvent(
                                      email: widget.emailController.text,
                                      password: widget.passwordController.text,
                                      confirmPassword: widget
                                          .confirmPasswordController.text)),
                              child: (snapshot.data ==
                                      LoginCheckStates.LOADING_STATE)
                                  ? buildLoadingWidget()
                                  : Text(
                                      "Submit",
                                    ))),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: (snapshot.data ==
                                  LoginCheckStates.USER_NOT_FOUND_STATE)
                              ? [
                                  Text(
                                    "Wrong email/password",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  TextButton(
                                      onPressed: () =>
                                          switchScreenBloc.mapEventToState(
                                              SwitchScreenEvent.REGISTER_EVENT),
                                      child: TextButton(
                                          onPressed: () => switchScreenBloc
                                              .mapEventToState(SwitchScreenEvent
                                                  .REGISTER_EVENT),
                                          child: Text(
                                            "Register",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                decoration:
                                                    TextDecoration.underline),
                                          )))
                                ]
                              : (snapshot.data ==
                                      LoginCheckStates.FILL_EMPTY_FIELDS_STATE)
                                  ? [
                                      Text(
                                        "Fill in empty fields",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      TextButton(
                                          onPressed: () => switchScreenBloc
                                              .mapEventToState(SwitchScreenEvent
                                                  .REGISTER_EVENT),
                                          child: Text(
                                            "Register",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                decoration:
                                                    TextDecoration.underline),
                                          ))
                                    ]
                                  : [
                                      Text(
                                        "Not registered yet?",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      TextButton(
                                          onPressed: () => switchScreenBloc
                                              .mapEventToState(SwitchScreenEvent
                                                  .REGISTER_EVENT),
                                          child: Text(
                                            "Register",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                decoration:
                                                    TextDecoration.underline),
                                          ))
                                    ]),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
