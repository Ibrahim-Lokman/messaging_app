import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:messaging_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:messaging_app/features/profile/data/profile_repository.dart';
import 'package:messaging_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:messaging_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:messaging_app/features/profile/presentation/pages/profile_page.dart';
import 'package:messaging_app/features/profile/domain/entities/profile.dart';
import 'package:messaging_app/features/home/domain/repositories/posts_repository.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/contacts/presentation/pages/contacts_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/home/domain/entities/post.dart';
import '../../features/home/presentation/pages/comments_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/contacts',
        builder: (context, state) => const ContactsPage(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          final otherUser = state.extra as User;
          return BlocProvider(
            create: (context) =>
                ChatBloc(chatRepository: context.read<ChatRepository>()),
            child: ChatPage(otherUser: otherUser),
          );
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthAuthenticated) {
            return ProfilePage(uid: authState.uid);
          }
          return const Scaffold(body: Center(child: Text('Not authenticated')));
        },
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) {
          final uid = state.extra as String;
          return EditProfilePage(uid: uid);
        },
      ),
      GoRoute(
        path: '/comments',
        builder: (context, state) {
          final post = state.extra as Post;
          return CommentsPage(post: post);
        },
      ),
    ],
  );
}
