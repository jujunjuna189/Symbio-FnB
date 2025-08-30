import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pos_simple_v2/databases/outlet/model/model_outlet.dart';
import 'package:pos_simple_v2/databases/outlet/repository/repository_outlet.dart';
import 'package:pos_simple_v2/databases/user/model/model_user.dart';
import 'package:pos_simple_v2/databases/user/repository/repository_user.dart';
import 'package:pos_simple_v2/pages/profile/state/state_profile.dart';

class BlocProfile extends Cubit<StateProfile> {
  BlocProfile() : super(ProfileInitial());

  void initialPage() {
    emit(ProfileLoaded());
    getUser().then((res) {
      getOutlet();
    });
  }

  Future<void> getUser() async {
    final currentState = state as ProfileLoaded;
    await RepositoryUser.instance.get().then((res) {
      List<ModelUser> users = [];
      users.addAll(res.map((res) => ModelUser.fromMap(res)).toList());

      if (users.isEmpty) return;
      emit(currentState.copyWith(user: users.first));
    });
  }

  Future<void> getOutlet() async {
    final currentState = state as ProfileLoaded;
    await RepositoryOutlet.instance.get().then((res) {
      List<ModelOutlet> outlets = [];
      outlets.addAll(res.map((res) => ModelOutlet.fromMap(res)).toList());

      if (outlets.isEmpty) return;
      emit(currentState.copyWith(outlet: outlets.first));
    });
  }

  void saveUser({required ModelUser user}) async {
    EasyLoading.show();
    if (user.id == null) {
      await RepositoryUser.instance.add(user).then((res) {
        EasyLoading.dismiss();
        getUser();
      });
    } else {
      await RepositoryUser.instance.update(user).then((res) {
        EasyLoading.dismiss();
        getUser();
      });
    }
  }

  void saveOutlet({required ModelOutlet outlet}) async {
    EasyLoading.show();
    if (outlet.id == null) {
      await RepositoryOutlet.instance.add(outlet).then((res) {
        EasyLoading.dismiss();
        getOutlet();
      });
    } else {
      await RepositoryOutlet.instance.update(outlet).then((res) {
        EasyLoading.dismiss();
        getOutlet();
      });
    }
  }

  @override
  void onChange(Change<StateProfile> change) {
    super.onChange(change);
  }
}
