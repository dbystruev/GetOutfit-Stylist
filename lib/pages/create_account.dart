import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final GlobalKey formKey = GlobalKey<FormState>();
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        titleText: 'Set up your profile',
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Must be at least 3 characters',
                          labelText: 'Username',
                          labelStyle: TextStyle(fontSize: 15),
                        ),
                        onSaved: (val) => username = val,
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
    );
  }

  void submit() {
    final FormState form = formKey.currentState;
    form.save();
    Navigator.pop(context, username);
  }
}
