import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_post/cache/cache_manager.dart';
import 'package:mobx_post/features/login/model/request_model.dart';
import 'package:mobx_post/features/login/service/Login_service.dart';
import 'package:mobx_post/product/enums/preferences_key.dart';
import 'package:mobx_post/product/enums/state_enum.dart';
part 'login_viewmodel.g.dart';

class LoginViewModel = _LoginViewModelBase with _$LoginViewModel;

abstract class _LoginViewModelBase with Store {
  _LoginViewModelBase() {
    currentUser();
  }
  final LoginService loginService = LoginService();
  final CacheManager cacheManager = CacheManager.instance;

  @observable
  String error = "";

  @observable
  String token = "";

  @observable
  LoginState state = LoginState.LoginInitial;

  @observable
  bool isLoading = false;

  @action
  Future<void> login({required RequestUserModel requestUserModel}) async {
    changeLoadingStatus();
    final data = await loginService.login(requestModel: requestUserModel);
    await cacheManager.setStringValue(
        key: PreferencesKey.token, value: data?.token ?? "");
    changeLoadingStatus();
    if (data != null) {
      String getToken = cacheManager.getStringValue(key: PreferencesKey.token);
      token = getToken;
      debugPrint("login Token: " + getToken);
      state = LoginState.LoginSuccess;
    } else {
      error = "Giriş Hatası.";
      state = LoginState.LoginError;
    }
  }

  void currentUser() {
    changeLoadingStatus();
    String getToken = cacheManager.getStringValue(key: PreferencesKey.token);
    changeLoadingStatus();
    if (getToken != "") {
      state = LoginState.LoginCache;
      token = getToken;
    } else {
      state = LoginState.LoginInitial;
    }
  }

  @action
  void changeLoadingStatus() {
    isLoading = !isLoading;
    if (isLoading) {
      state = LoginState.LoginLoading;
    } else {
      state = LoginState.LoginInitial;
    }
  }

  @action
  void tryLogin() {
    state = LoginState.LoginInitial;
  }

  @action
  Future<void> logOut() async {
    changeLoadingStatus();
    await cacheManager.setStringValue(key: PreferencesKey.token, value: "");
    changeLoadingStatus();
    state = LoginState.LoginInitial;
  }
}
