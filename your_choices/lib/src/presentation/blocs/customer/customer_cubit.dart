import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_single_customer_usecase.dart';

import '../../../domain/entities/customer/customer_entity.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final GetSingleCustomerUseCase getSingleCustomerUseCase;

  CustomerCubit({required this.getSingleCustomerUseCase})
      : super(CustomerInitial());

  Future<void> getSingleCustomer({required String uid}) async {
    emit(CustomerLoading());

    try {
      final data = getSingleCustomerUseCase.call(uid);
      data.listen(
        (customerData) {
          if (customerData.first.transaction?.isNotEmpty ?? false) {
            customerData.first.transaction!.sort(
              (a, b) {
                final newA = a.date!.toDate();
                final newB = b.date!.toDate();
                return newB.compareTo(newA);
              },
            );
          }
          emit(
            CustomerLoaded(
              customerEntity: customerData.first,
            ),
          );
        },
      );
      // if (data.transaction?.isNotEmpty ?? false) {
      //   data.transaction!.sort(
      //     (a, b) {
      //       final newA = a.date!.toDate();
      //       final newB = b.date!.toDate();
      //       return newB.compareTo(newA);
      //     },
      //   );
      // }

    } on SocketException catch (_) {
      emit(CustomerFailure());
    } catch (e) {
      emit(CustomerFailure());
    }
  }

  // Future<void> updateCustomer({required CustomerEntity customer}) async {
  //   emit(CustomerLoading());
  //   try {
  //     await customerUseCase.updateCustomerCall(customer);
  //     emit(CustomerLoaded(customerEntity: ));
  //   } on SocketException catch (e) {
  //     emit(CustomerFailure());
  //   } catch (e) {
  //     emit(CustomerFailure());
  //   }
  // }
}
