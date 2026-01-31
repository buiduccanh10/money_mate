import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/data/repository/local_auth_repository.dart';
import 'app_lock_state.dart';

class AppLockCubit extends Cubit<AppLockState> {
  final LocalAuthRepository _localAuthRepo;

  AppLockCubit({required LocalAuthRepository localAuthRepo})
    : _localAuthRepo = localAuthRepo,
      super(const AppLockState());

  Future<void> authenticate(String reason, bool isLockEnabled) async {
    if (state.isAuthenticating) return;

    if (!isLockEnabled) {
      emit(
        state.copyWith(isAuthorized: true, status: AppLockStatus.authorized),
      );
      return;
    }

    emit(
      state.copyWith(
        isAuthenticating: true,
        status: AppLockStatus.authenticating,
      ),
    );

    try {
      final success = await _localAuthRepo.authenticate(reason);
      emit(
        state.copyWith(
          isAuthorized: success,
          isAuthenticating: false,
          status: success
              ? AppLockStatus.authorized
              : AppLockStatus.unauthorized,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isAuthorized: false,
          isAuthenticating: false,
          status: AppLockStatus.unauthorized,
        ),
      );
    }
  }

  void lock() {
    emit(
      state.copyWith(isAuthorized: false, status: AppLockStatus.unauthorized),
    );
  }
}
