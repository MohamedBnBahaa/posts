import 'package:clean_architecture_posts_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post.dart';

class AddPostUseCase{
  final PostsRepository repository;

  AddPostUseCase(this.repository);
  Future<Either<Failure, Unit>>call(Post post) async {
    return repository.updatePost(post);
  }
}