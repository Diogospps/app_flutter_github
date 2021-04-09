import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app2/pagetwo.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Procure um usuario no GitHub';

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.black),
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(appTitle),
          centerTitle: true,
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

Future<Users> futureRequest;

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class Users {
  final String avatar_url;
  final String login;
  final int followers;
  final int following;
  final String created_at;

  Users(
      {this.avatar_url,
      this.login,
      this.followers,
      this.following,
      this.created_at});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        avatar_url: json['avatar_url'],
        login: json['login'],
        followers: json['followers'],
        following: json['following'],
        created_at: json['created_at']);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  Future<Users> futureUsers;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  var forminput;

  Future<Users> pegalink() async {
    final response =
        await http.get(Uri.https("api.github.com", "users/$forminput"));
    if (response.statusCode == 200) {
      return Users.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  void submit() {
    _formKey.currentState.save();
    futureRequest = pegalink();

    Timer(
        Duration(seconds: 2),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => PageTwo())));
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            cursorColor: Colors.black,
            decoration:
                InputDecoration(labelText: 'Digite o usuário desejado:'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Escreva o usuário';
              }
              return null;
            },
            onSaved: (input) => forminput = input,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  submit();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Carregando...')));
                }
              },
              child: Text('Pesquisar'),
            ),
          ),
        ],
      ),
    );
  }
}
