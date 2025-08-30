import 'package:pos_simple_v2/databases/outlet/model/model_outlet.dart';
import 'package:pos_simple_v2/databases/user/model/model_user.dart';

abstract class StateProfile {}

class ProfileInitial extends StateProfile {}

class ProfileLoading extends StateProfile {}

class ProfileLoaded extends StateProfile {
  final ModelUser? user;
  final ModelOutlet? outlet;
  ProfileLoaded({this.user, this.outlet});

  ProfileLoaded copyWith({ModelUser? user, ModelOutlet? outlet}) {
    return ProfileLoaded(user: user ?? this.user, outlet: outlet ?? this.outlet);
  }
}

class ProfileAdded extends StateProfile {
  ProfileAdded();
}

class ProfileError extends StateProfile {
  final String message;

  ProfileError(this.message);
}
