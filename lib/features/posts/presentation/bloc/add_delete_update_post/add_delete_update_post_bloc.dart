import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture_posts_app/core/strings/failures.dart';
import 'package:clean_architecture_posts_app/core/strings/messages.dart';
import 'package:clean_architecture_posts_app/features/posts/domain/entities/post.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/add_post.dart';
import '../../../domain/usecases/delete_post.dart';
import '../../../domain/usecases/update_post.dart';

part 'add_delete_update_post_event.dart';
part 'add_delete_update_post_state.dart';

class AddDeleteUpdatePostBloc
    extends Bloc<AddDeleteUpdatePostEvent, AddDeleteUpdatePostState> {
  final AddPostUseCase addPost;
  final DeletePostUseCase deletePost;
  final UpdatePostUseCase updatePost;
  AddDeleteUpdatePostBloc({
    required this.addPost,
    required this.deletePost,
    required this.updatePost
  }) : super(AddDeleteUpdatePostInitial()) {
    on<AddDeleteUpdatePostEvent>((event, emit) async {
      if(event is AddPostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDoneMessage = await addPost(event.post);
        emit(_eitherDoneMessageOrErrorState(failureOrDoneMessage, addSuccessMessage));

      }else if(event is UpdatePostEvent){
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDoneMessage = await updatePost(event.post);
        emit(_eitherDoneMessageOrErrorState(failureOrDoneMessage, updateSuccessMessage));

      }else if(event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDoneMessage = await deletePost(event.postId);
        emit(_eitherDoneMessageOrErrorState(failureOrDoneMessage, deleteSuccessMessage));
      }
    });
  }

  AddDeleteUpdatePostState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdatePostState(message: _mapFailureToMessage(failure)),
      (_) => MessageAddDeleteUpdatePostState(message: message),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch(failure.runtimeType) {
      case ServerFailure: return serverFailureMessage;
      case OfflineFailure: return offlineFailureMessage;
      default: return defaultFailureMessage;
    }
  }
}
