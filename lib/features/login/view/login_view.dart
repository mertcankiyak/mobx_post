import 'package:flutter/material.dart';
import 'package:mobx_post/cache/cache_manager.dart';
import 'package:mobx_post/features/login/model/request_model.dart';
import 'package:mobx_post/features/login/service/Login_service.dart';
import 'package:mobx_post/features/login/viewmodel/login_viewmodel.dart';
import 'package:mobx_post/product/constants/string_constants.dart';
import 'package:mobx_post/product/enums/state_enum.dart';
import 'package:mobx_post/product/mixin/form_validate.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LoginView extends StatelessWidget with FormValidate {
  LoginView({Key? key}) : super(key: key);

  final LoginViewModel _loginViewModel = LoginViewModel();

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailEditTextController =
      TextEditingController();
  final TextEditingController _passwordEditTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("build metodu çalıştı");
    return Scaffold(
      appBar: _buildAppBar(),
      body: Observer(builder: (_) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loginViewModel.state == LoginState.LoginInitial) ...[
              _buildLoginForm(context),
            ] else if (_loginViewModel.state == LoginState.LoginLoading) ...[
              _buildProgressBar(),
            ] else if (_loginViewModel.state == LoginState.LoginSuccess) ...[
              _buildLoginSuccessText(context),
              _buildSuccessLogOutButton(context),
            ] else if (_loginViewModel.state == LoginState.LoginCache) ...[
              _buildCacheLoginText(context),
              _buildCacheLogOutButton(context),
            ] else if (_loginViewModel.state == LoginState.LoginError) ...[
              _buildLoginErrorText(context),
              _buildErrorTryLoginButton(context),
            ],
          ],
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Login View (MobX)"),
    );
  }

  Center _buildLoginSuccessText(BuildContext context) {
    return Center(
      child: Text(
        "Giriş Başarılı: " + _loginViewModel.token,
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.center,
      ),
    );
  }

  ElevatedButton _buildSuccessLogOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: (() {
        _loginViewModel.logOut();
      }),
      child: const Text("Çıkış Yap"),
    );
  }

  Center _buildProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Center _buildLoginErrorText(BuildContext context) {
    return Center(
      child: Text(
        _loginViewModel.error,
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.center,
      ),
    );
  }

  ElevatedButton _buildErrorTryLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: (() {
        _loginViewModel.tryLogin();
      }),
      child: const Text("Tekrar Giriş Yap"),
    );
  }

  Center _buildCacheLoginText(BuildContext context) {
    return Center(
      child: Text(
        "Kullanıcı Cacheden Geldi: " + _loginViewModel.token,
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.center,
      ),
    );
  }

  ElevatedButton _buildCacheLogOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: (() {
        _loginViewModel.logOut();
      }),
      child: const Text("Çıkış Yap"),
    );
  }

  Form _buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailTextformField(),
          _buildPasswordTextFormField(),
          _buildLoginButton(context)
        ],
      ),
    );
  }

  Padding _buildEmailTextformField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _emailEditTextController,
        validator: emailValidation,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: email,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Padding _buildPasswordTextFormField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        obscureText: true,
        controller: _passwordEditTextController,
        validator: passwordControl,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: password,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  ElevatedButton _buildLoginButton(BuildContext context) {
    return ElevatedButton(
        onPressed: (() {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            _loginViewModel.login(
              requestUserModel: RequestUserModel(
                email: _emailEditTextController.text.trim(),
                password: _passwordEditTextController.text.trim(),
              ),
            );
          }
        }),
        child: Text(girisYap));
  }
}
