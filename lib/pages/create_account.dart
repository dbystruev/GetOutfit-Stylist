import 'dart:async';
import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        titleText: 'Set up your profile',
        removeBackButton: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  child: Center(
                    child: Text(
                      'Create a username',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  padding: EdgeInsets.only(top: 25),
                ),
                Padding(
                  child: Container(
                    child: Form(
                      child: TextFormField(
                        autovalidate: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Must be at least 3 characters',
                          labelText: 'Username',
                          labelStyle: TextStyle(fontSize: 15),
                        ),
                        onSaved: (val) => username = val,
                        validator: (val) {
                          if (val.trim().length < 3)
                            return 'Username too short';
                          if (12 < val.trim().length)
                            return 'Username too long';
                          return null;
                        },
                      ),
                      key: formKey,
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                ),
                GestureDetector(
                  child: Container(
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Theme.of(context).primaryColor,
                    ),
                    height: 50,
                    width: 350,
                  ),
                  onTap: submit,
                ),
              ],
            ),
          ),
        ],
      ),
      key: scaffoldKey,
    );
  }

  void submit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();

      final SnackBar snackbar = SnackBar(
        content: Text('Welcome, $username!'),
      );

      scaffoldKey.currentState.showSnackBar(snackbar);

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });
    }
  }
}
