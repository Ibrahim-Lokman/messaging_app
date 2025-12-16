import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging_app/features/profile/data/profile_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/contacts/domain/repositories/contacts_repository.dart';
import 'features/contacts/data/contacts_repository_impl.dart';
import 'features/contacts/presentation/bloc/contacts_bloc.dart';
import 'features/contacts/presentation/bloc/contacts_bloc.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/data/chat_repository_impl.dart';
import 'features/home/domain/repositories/posts_repository.dart';
import 'features/home/data/posts_repository_impl.dart';
import 'core/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Hive.initFlutter();

  final notificationService = NotificationService();
  try {
    await notificationService.initialize();
  } catch (e) {
    debugPrint('NotificationService initialization failed: $e');
  }

  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  const MyApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => FirebaseAuthRepository(),
        ),
        RepositoryProvider<ContactsRepository>(
          create: (_) => FirebaseContactsRepository(),
        ),
        RepositoryProvider<ChatRepository>(
          create: (_) => FirebaseChatRepository(),
        ),
        RepositoryProvider<PostsRepository>(
          create: (_) => FirebasePostsRepository(),
        ),
        RepositoryProvider<ProfileRepository>(
          create:
              (
                _,
              ) => /* TODO: Provide your ProfileRepository implementation here */
                  throw UnimplementedError(
                    'Provide ProfileRepository implementation',
                  ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              notificationService: notificationService,
            ),
          ),
          BlocProvider(
            create: (context) => ContactsBloc(
              contactsRepository: context.read<ContactsRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Flutter Chat App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
