import 'package:your_choices/src/domain/entities/customer/customer_entity.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';

class SignUpCustomerUseCase {
  final FirebaseRepository repository;

  SignUpCustomerUseCase({required this.repository});

  Future<void> call(CustomerEntity customer) {
    return repository.signUpCustomer(customer);
  }
}
