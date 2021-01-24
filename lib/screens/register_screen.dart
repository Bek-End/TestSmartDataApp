import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/bloc/register_check_bloc.dart';
import 'package:test_app/bloc/switch_screen_bloc.dart';
import 'package:test_app/elements/loading_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          switchScreenBloc.mapEventToState(SwitchScreenEvent.LOGIN_EVENT);
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text("Register"),
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(EvaIcons.arrowBack),
                  onPressed: () => switchScreenBloc
                      .mapEventToState(SwitchScreenEvent.LOGIN_EVENT))),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(16),
              child: StreamBuilder(
                  stream: registerCheckBloc.subject.stream,
                  initialData: registerCheckBloc.defaultRegisterState,
                  builder:
                      (context, AsyncSnapshot<RegisterCheckStates> snapshot) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: widget.nameController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            hintText: "Enter your name",
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
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
                                      RegisterCheckStates
                                          .WRONG_EMAIL_INPUT_STATE)
                                  ? "Invalid Email"
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
                              hintText: "Enter password",
                              errorText: (snapshot.data ==
                                      RegisterCheckStates
                                          .PASSWORDS_NOT_EQUAL_STATE)
                                  ? "Passwords don't match"
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
                              hintText: "Enter password once again",
                              errorText: (snapshot.data ==
                                      RegisterCheckStates
                                          .PASSWORDS_NOT_EQUAL_STATE)
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
                              onPressed: () => registerCheckBloc
                                  .checkCredentials(RegisterCheckEvent(
                                      user: widget.nameController.text,
                                      email: widget.emailController.text,
                                      password: widget.passwordController.text,
                                      confirmPassword: widget
                                          .confirmPasswordController.text)),
                              child: (snapshot.data ==
                                      RegisterCheckStates.LOADING_STATE)
                                  ? buildLoadingWidget()
                                  : Text("Register")),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: (snapshot.data ==
                                  RegisterCheckStates.ERROR_REGISTER_STATE)
                              ? [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Error registering the user",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ]
                              : (snapshot.data ==
                                      RegisterCheckStates.ERROR_LOGIN_STATE)
                                  ? [
                                      Text(
                                        "Successfully registered, but error while logging in, press ",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      TextButton(
                                          onPressed: () => switchScreenBloc
                                              .mapEventToState(SwitchScreenEvent
                                                  .LOGIN_EVENT),
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                                color: Colors.orange,
                                                decoration:
                                                    TextDecoration.underline),
                                          ))
                                    ]
                                  : (snapshot.data ==
                                          RegisterCheckStates
                                              .FILL_EMPTY_FIELDS_STATE)
                                      ? [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            "Fill in empty fields",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ]
                                      : [],
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
