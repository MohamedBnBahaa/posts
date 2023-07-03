import 'package:clean_architecture_posts_app/core/util/snackbar_message.dart';
import 'package:clean_architecture_posts_app/core/widgets/loading_widget.dart';
import 'package:clean_architecture_posts_app/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:clean_architecture_posts_app/features/posts/presentation/pages/posts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/post.dart';
import '../widgets/post_add_update_page/form_widget.dart';

class PostAddUpdatePage extends StatelessWidget {
  final Post? post;
  final bool isUpdatePost;
  const PostAddUpdatePage({Key? key, this.post, required this.isUpdatePost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(title: Text(isUpdatePost ? "Edit Post" : "Add Post",),);
  }

  Widget _buildBody(){
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: BlocConsumer<AddDeleteUpdatePostBloc, AddDeleteUpdatePostState>(
            builder: (context, state){
              if(state is LoadingAddDeleteUpdatePostState){
                return LoadingWidget();
              }
              return FormWidget(
                isUpdatePost: isUpdatePost,
                post: isUpdatePost ? post : null
              );
            },
            listener: (context, state){
              if(state is MessageAddDeleteUpdatePostState){
                SnackBarMessage().showSuccessSnackBar(
                    message: state.message,
                    context: context
                );
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => PostsPage(),
                  ),
                  (route) => false,
                );
              }else if(state is ErrorAddDeleteUpdatePostState){
                SnackBarMessage().showErrorSnackBar(
                    message: state.message,
                    context: context
                );
              }
            },
        ),
      ),
    );
  }
}
