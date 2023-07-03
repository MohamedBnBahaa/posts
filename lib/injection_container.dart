import 'package:clean_architecture_posts_app/core/network/network_info.dart';
import 'package:clean_architecture_posts_app/features/posts/data/data_sources/post_local_data_source.dart';
import 'package:clean_architecture_posts_app/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:clean_architecture_posts_app/features/posts/data/repositories/post_repositories_impl.dart';
import 'package:clean_architecture_posts_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:clean_architecture_posts_app/features/posts/domain/usecases/add_post.dart';
import 'package:clean_architecture_posts_app/features/posts/domain/usecases/delete_post.dart';
import 'package:clean_architecture_posts_app/features/posts/domain/usecases/get_all_posts.dart';
import 'package:clean_architecture_posts_app/features/posts/domain/usecases/update_post.dart';
import 'package:clean_architecture_posts_app/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:clean_architecture_posts_app/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

//! Features - posts

//Bloc
sl.registerFactory(() => PostsBloc(getAllPosts: sl()));
sl.registerFactory(() => AddDeleteUpdatePostBloc(
    addPost: sl(),
    deletePost: sl(),
    updatePost: sl(),
));


//UseCases
sl.registerLazySingleton(() => GetAllPostsUseCase(sl()));
sl.registerLazySingleton(() => AddPostUseCase(sl()));
sl.registerLazySingleton(() => DeletePostUseCase(sl()));
sl.registerLazySingleton(() => UpdatePostUseCase(sl()));

//Repository
sl.registerLazySingleton<PostsRepository>(() => PostsRepositoryImpl(
    networkInfo: sl(),
    remoteDataSource: sl(),
    localDataSource: sl(),
));

//DataSources
sl.registerLazySingleton<PostRemoteDataSource>(
        () => PostRemoteDataSourceImpl(client: sl())
);
sl.registerLazySingleton<PostLocalDataSource>(
        () => PostLocalDataSourceImpl(sharedPreferences: sl())
);


//! Core
sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//! External
final sharedPreferences = await SharedPreferences.getInstance();

sl.registerLazySingleton(() => sharedPreferences);
sl.registerLazySingleton(() => http.Client());
sl.registerLazySingleton(() => InternetConnectionChecker());

}