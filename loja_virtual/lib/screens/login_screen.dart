import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text('CRIAR CONTA',
                style: TextStyle(fontSize: 15,
              color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignupScreen())
                );
              },
          )
        ]
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (text) => text.isEmpty || !text.contains('@') ? 'E-mail invalido' : null,
                ),
                SizedBox(height: 16,),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Senha'),
                  obscureText: true,
                  validator:
                      (text) => text.isEmpty || text.length < 6 ? 'Senha invalido' : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: (){},
                    child: Text('Esqueci minha senha'),
                    padding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(height: 16,),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text('Entrar',
                      style: TextStyle(fontSize: 18),),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        model.signIn();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
