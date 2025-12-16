import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/contacts/presentation/pages/contacts_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/auth/domain/entities/user.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
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
            create: (context) => ChatBloc(
              chatRepository: context.read<ChatRepository>(),
            ),
            child: ChatPage(otherUser: otherUser),
          );
        },
      ),
    ],
  );
}
