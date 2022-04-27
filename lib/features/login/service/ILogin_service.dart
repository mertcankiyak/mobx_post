import 'package:mobx_post/features/login/model/request_model.dart';
import 'package:mobx_post/features/login/model/response_model.dart';

abstract class ILoginService {
  Future<ResponseTokenModel?> login({RequestUserModel? requestModel});
}
