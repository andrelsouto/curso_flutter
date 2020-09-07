import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final adressController = TextEditingController();
  final _scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
          title: Text('Criar conta'),
          centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if (model.isLoading) return Center(child: CircularProgressIndicator(),);
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Nome Completo'),
                  validator:
                      (text) => text.isEmpty ? 'Nome inválido' : null,
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (text) => text.isEmpty || !text.contains('@') ? 'E-mail inválido' : null,
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: passController,
                  decoration: InputDecoration(hintText: 'Senha'),
                  obscureText: true,
                  validator:
                      (text) => text.isEmpty || text.length < 6 ? 'Senha invalido' : null,
                ),
                SizedBox(height: 16,),
                TextFormField(
                  controller: adressController,
                  decoration: InputDecoration(hintText: 'Endereço'),
                  validator:
                      (text) => text.isEmpty ? 'Endereço invalido' : null,
                ),
                SizedBox(height: 16,),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text('Criar conta',
                      style: TextStyle(fontSize: 18),),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        final userData = {
                          'name': nameController.text,
                          'email': emailController.text,
                          'address': adressController.text
                        };
                        model.signUp(
                            userData: userData,
                            pass: passController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail);
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
  void _onSuccess() {
    _scaffold.currentState.showSnackBar(
      SnackBar(
        content: Text('Usuário criado com sucesso!'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      )
    );
    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.of(context).pop());
  }

  void _onFail() {
    _scaffold.currentState.showSnackBar(
        SnackBar(
          content: Text('Falha ao criar usuário!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
