import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class GetSingleCustomerUseCase {
  final FirebaseRepository repository;

  GetSingleCustomerUseCase({required this.repository});

  Future<CustomerEntity> call(String uid) {
    return repository.getSingleCustomer(uid);
  }
}
