import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/network/network_info.dart';
import 'core/network/auth_interceptor.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/products/data/datasources/product_local_data_source.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/models/product_model.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/usecases/get_products_usecase.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/pages/product_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());
  final productBox = await Hive.openBox<ProductModel>('products');

  final storage = const FlutterSecureStorage();
  final dio = Dio();
  final connectivity = Connectivity();
  final networkInfo = NetworkInfoImpl(connectivity);

  dio.interceptors.add(AuthInterceptor(storage: storage, dio: dio));
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  // Dependencies
  final authRemoteDataSource = AuthRemoteDataSourceImpl(dio: dio);
  final authLocalDataSource = AuthLocalDataSourceImpl(storage: storage);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );
  final loginUseCase = LoginUseCase(authRepository);

  final productRemoteDataSource = ProductRemoteDataSourceImpl(dio: dio);
  final productLocalDataSource = ProductLocalDataSourceImpl(productBox: productBox);
  final productRepository = ProductRepositoryImpl(
    remoteDataSource: productRemoteDataSource,
    localDataSource: productLocalDataSource,
    networkInfo: networkInfo,
  );
  final getProductsUseCase = GetProductsUseCase(productRepository);

  runApp(MyApp(
    loginUseCase: loginUseCase,
    getProductsUseCase: getProductsUseCase,
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final GetProductsUseCase getProductsUseCase;
  final AuthRepositoryImpl authRepository;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.getProductsUseCase,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(loginUseCase: loginUseCase, authRepository: authRepository)..add(AuthCheckRequested())),
        BlocProvider(create: (_) => ProductBloc(getProductsUseCase: getProductsUseCase)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Connectée App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const ProductListPage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
