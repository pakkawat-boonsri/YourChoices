import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';

import '../../../repositories/firebase_repository.dart';

class SignUpVendorUseCase {
  final FirebaseRepository repository;

  SignUpVendorUseCase({required this.repository});

  Future<void> call(VendorEntity vendorEntity) {
    return repository.signUpVendor(vendorEntity);
  }
}
