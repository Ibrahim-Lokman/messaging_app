import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/posts_repository.dart';
import '../../domain/entities/post.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;
  StreamSubscription? _postsSubscription;

  PostsBloc({required this.postsRepository}) : super(PostsInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<CreatePost>(_onCreatePost);
    on<DeletePost>(_onDeletePost);
    on<_PostsUpdated>(_onPostsUpdated);
    on<_PostsErrorOccurred>(_onPostsErrorOccurred);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    try {
      await _postsSubscription?.cancel();
      _postsSubscription = postsRepository.getPosts().listen(
        (posts) {
          add(_PostsUpdated(posts));
        },
        onError: (error) {
          add(_PostsErrorOccurred(error.toString()));
        },
      );
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onCreatePost(CreatePost event, Emitter<PostsState> emit) async {
    try {
      await postsRepository.createPost(
        event.userId,
        event.username,
        event.userPhotoUrl,
        event.content,
      );
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostsState> emit) async {
    try {
      await postsRepository.deletePost(event.postId);
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  Future<void> _onPostsUpdated(_PostsUpdated event, Emitter<PostsState> emit) async {
    emit(PostsLoaded(event.posts));
  }

  Future<void> _onPostsErrorOccurred(_PostsErrorOccurred event, Emitter<PostsState> emit) async {
    emit(PostsError(event.error));
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}

// Internal events
class _PostsUpdated extends PostsEvent {
  final List<Post> posts;

  const _PostsUpdated(this.posts);

  @override
  List<Object?> get props => [posts];
}

class _PostsErrorOccurred extends PostsEvent {
  final String error;

  const _PostsErrorOccurred(this.error);

  @override
  List<Object?> get props => [error];
}

