import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_networkpractice/second.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<HomePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool hidepassword=true;
  bool _loading = false;

  dynamic res;

  Future<void> _performLogin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty) {
      Fluttertoast.showToast(msg: "Invalid Username");
      return;
    }
    if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Invalid password");
      return;
    }
    setState(() {
      _loading = true;
    });
    // Map<String, dynamic> postData = {
    //   "username": username,
    //   "password": password,
    // };
    FormData formData = FormData.fromMap({
      "username": username,
      "password": password,
    });

    Response response =
    await Dio().post("https://networkintern.herokuapp.com/login",
        data: formData,
        options: Options(
          validateStatus: (status) => status < 500,
        ));

    setState(() {
      res = response.data;
      _loading = false;
    });
    if (response.data['status']) {
       Navigator.of(context).push(
         MaterialPageRoute(
           builder: (context) => SecondPage(
             user: response.data['user'] ??
                 "", // response.data['user'] == null ? "" : response.data['user']
           ),
         ),
       );
    } else {
      Fluttertoast.showToast(msg: response.data['message']);
      print(response.data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller:_usernameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'UserName',
                    hintText: 'SunilChowdary'),
              ),
              SizedBox(
                height: 24,
              ),
              TextField(
                controller: _passwordController,
                obscureText: hidepassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            hidepassword= !hidepassword;
                          });
                        },
                        icon:Icon(hidepassword?Icons.visibility_off:Icons.visibility)
                    ),
                    labelText: 'password',
                    hintText: 'password'),
              ),
              SizedBox(
                height: 24,
              ),
              if (_loading)
                Center(
                  child: CircularProgressIndicator(),
                )
              else
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    _performLogin();
                  },
                  child: Text("Login"),
                ),
              if (res != null) Text("${res['user']}")
            ],
          ),
        ),
      ),
    );
  }
}
