import '../../../../entities/vendor/filter_options/filter_option_entity.dart';
import '../../../../repositories/firebase_repository.dart';

class DeleteFilterOptionInMenuUseCase {
  final FirebaseRepository repository;

  DeleteFilterOptionInMenuUseCase({required this.repository});

  Future<void> call(FilterOptionEntity filterOptionEntity) {
    return repository.deleteFilterOptionInMenu(filterOptionEntity);
  }
}
