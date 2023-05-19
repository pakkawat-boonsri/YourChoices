import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:your_choices/src/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:your_choices/src/data/repositories/firebase_repository_impl.dart';
import 'package:your_choices/src/domain/repositories/firebase_repository.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_current_uid_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/get_single_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/restaurant/get_all_restaurant_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/sign_up_customer_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/customer/update_customer_info_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/is_sign_in_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/sign_in_role_usercase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/sign_in_user_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/sign_out_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/utilities/upload_image_to_storage_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/create_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/read_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filer_option/update_filter_option_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/get_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/get_single_vendor_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/is_active_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/add_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/create_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/delete_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/delete_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/get_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/filter_option_in_menu/update_filter_option_in_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/menu/update_menu_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/sign_up_vendor_usecase.dart';
import 'package:your_choices/src/domain/usecases/firebase_usecases/vendor/update_restaurant_info_usecase.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/cart/cart_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/favorite/favorite_cubit.dart';
import 'package:your_choices/src/presentation/blocs/customer_bloc/restaurant/restaurant_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/add_add_ons/add_add_ons_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/add_filter_in_menu/add_filter_in_menu_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/add_filter_option/add_filter_option_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/filter_option/filter_options_cubit.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/menu/menu_cubit.dart';

import 'src/data/data_sources/remote_data_source_impl/remote_data_source_impl.dart';
import 'src/domain/usecases/firebase_usecases/vendor/filer_option/delete_filter_option_usecase.dart';
import 'src/presentation/blocs/customer_bloc/customer/customer_cubit.dart';
import 'src/presentation/blocs/utilities_bloc/auth/auth_cubit.dart';
import 'src/presentation/blocs/utilities_bloc/credential/credential_cubit.dart';
import 'src/presentation/blocs/vendor_bloc/filter_option_in_menu/filter_option_in_menu_cubit.dart';
import 'src/presentation/blocs/vendor_bloc/vendor/vendor_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //cubit
  sl.registerFactory(
    () => AuthCubit(
      signInRoleUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CustomerCubit(
      getSingleCustomerUseCase: sl.call(),
      updateCustomerInfoUseCase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => FavoriteCubit(
    ),
  );
  sl.registerFactory(
    () => CartCubit(
    ),
  );
  sl.registerFactory(
    () => RestaurantCubit(
      getAllRestaurantUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => VendorCubit(
      getSingleVendorUseCase: sl.call(),
      isActiveUseCase: sl.call(),
      updateRestaurantInfoUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => CredentialCubit(
      getCurrentUidUseCase: sl.call(),
      signInUserUseCase: sl.call(),
      signUpVendorUseCase: sl.call(),
      signUpCustomerUseCase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => MenuCubit(
      createMenuUseCase: sl.call(),
      deleteMenuUseCase: sl.call(),
      getMenuUseCase: sl.call(),
      updateMenuUseCase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => FilterOptionInMenuCubit(
      addFilterOptionInMenuUseCase: sl.call(),
      deleteFilterOptionInMenuUseCase: sl.call(),
      getFilterOptionInMenuUseCase: sl.call(),
      updateFilterOptionInMenuUseCase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => FilterOptionCubit(
      createFilterOptionUseCase: sl.call(),
      readFilterOptionUseCase: sl.call(),
      updateFilterOptionUseCase: sl.call(),
      deleteFilterOptionUseCase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => AddFilterOptionCubit(),
  );
  sl.registerFactory(
    () => AddAddOnsCubit(),
  );
  sl.registerFactory(
    () => AddFilterInMenuCubit(),
  );

  //use-cases customer
  sl.registerLazySingleton(
    () => GetSingleCustomerUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => GetCurrentUidUseCase(repository: sl.call()),
  );

  sl.registerLazySingleton(
    () => SignUpCustomerUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => GetAllRestaurantUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => UpdateCustomerInfoUseCase(repository: sl.call()),
  );

  //use-case vendor

  sl.registerLazySingleton(
    () => SignUpVendorUseCase(
      repository: sl.call(),
    ),
  );

  sl.registerLazySingleton(
    () => GetSingleVendorUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => IsActiveUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateRestaurantInfoUseCase(
      repository: sl.call(),
    ),
  );

  //use-case menu
  sl.registerLazySingleton(
    () => CreateMenuUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => GetMenuUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => GetFilterOptionInMenuUseCase(
      repository: sl.call(),
    ),
  );

  sl.registerLazySingleton(
    () => DeleteMenuUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateMenuUseCase(
      repository: sl.call(),
    ),
  );

  //menu-detail-usecases
  sl.registerLazySingleton(
    () => AddFilterOptionInMenuUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateFilterOptionInMenuUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteFilterOptionInMenuUseCase(
      repository: sl.call(),
    ),
  );

  //use-case filter option
  sl.registerLazySingleton(
    () => CreateFilterOptionUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => ReadFilterOptionUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateFilterOptionUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => DeleteFilterOptionUseCase(
      repository: sl.call(),
    ),
  );

  //utilities
  sl.registerLazySingleton(
    () => IsSignInUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => SignOutUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => UploadImageToStorageUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => SignInRoleUseCase(
      repository: sl.call(),
    ),
  );
  sl.registerLazySingleton(
    () => SignInUserUseCase(
      repository: sl.call(),
    ),
  );

  //repository
  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(remoteDataSource: sl.call()),
  );

  sl.registerLazySingleton<FirebaseRemoteDataSource>(
    () => FirebaseRemoteDataSourceImpl(
      firebaseFireStore: sl.call(),
      firebaseAuth: sl.call(),
      firebaseStorage: sl.call(),
    ),
  );
  //externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
