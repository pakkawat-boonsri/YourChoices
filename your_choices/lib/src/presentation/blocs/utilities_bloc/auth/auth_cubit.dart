import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_current_uid_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/is_sign_in_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/sign_in_role_usercase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignInUseCase isSignInUseCase;
  final GetCurrentUidUseCase getCurrentUidUseCase;
  final SignOutUseCase signOutUseCase;
  final SignInRoleUseCase signInRoleUseCase;

  AuthCubit({
    required this.signInRoleUseCase,
    required this.isSignInUseCase,
    required this.getCurrentUidUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isSignIn = await isSignInUseCase.call();

      if (isSignIn) {
        final String uid = await getCurrentUidUseCase.call();
        final String type = await signInRoleUseCase.call(uid);
        emit(Authenticated(
          uid: uid,
          type: type,
        ));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final String uid = await getCurrentUidUseCase.call();
      final String type = await signInRoleUseCase.call(uid);
      emit(
        Authenticated(
          uid: uid,
          type: type,
        ),
      );
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggingOut() async {
    try {
      await signOutUseCase.call();
      emit(UnAuthenticated());
    } catch (e) {
      emit(UnAuthenticated());
    }
  }
}
