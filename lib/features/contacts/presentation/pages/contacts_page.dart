import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<ContactsBloc>().add(ContactsLoadFriends(authState.uid));
    }
  }

  void _showAddFriendDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final authState = context.read<AuthBloc>().state;
    final currentUserId =
        authState is AuthAuthenticated ? authState.uid : null;

    if (currentUserId == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<ContactsBloc>(),
          child: AlertDialog(
            title: const Text('Add Friend'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter username to search',
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ContactsBloc, ContactsState>(
                    builder: (context, state) {
                      if (state is ContactsLoaded) {
                        if (state.error != null) {
                          return Text(
                            state.error!,
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        if (state.searchResult != null) {
                          final user = state.searchResult!;
                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: user.photoUrl != null
                                      ? NetworkImage(user.photoUrl!)
                                      : null,
                                  child: user.photoUrl == null
                                      ? Text(user.username[0].toUpperCase())
                                      : null,
                                ),
                                title: Text(user.username),
                                subtitle: Text(user.email),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<ContactsBloc>().add(
                                        ContactsAddFriend(
                                          currentUserId,
                                          user,
                                        ),
                                      );
                                  Navigator.of(dialogContext).pop();
                                },
                                child: const Text('Add User'),
                              ),
                            ],
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final username = usernameController.text.trim();
                  if (username.isNotEmpty) {
                    context
                        .read<ContactsBloc>()
                        .add(ContactsSearchUser(username));
                  }
                },
                child: const Text('Search'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (context, state) {
            if (state is ContactsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactsLoaded) {
              if (state.friends.isEmpty) {
                return const Center(child: Text('No friends yet'));
              }
              return ListView.builder(
                itemCount: state.friends.length,
                itemBuilder: (context, index) {
                  final friend = state.friends[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: friend.photoUrl != null
                          ? NetworkImage(friend.photoUrl!)
                          : null,
                      child: friend.photoUrl == null
                          ? Text(friend.username[0].toUpperCase())
                          : null,
                    ),
                    title: Text(friend.username),
                    subtitle: Text(friend.email),
                    onTap: () {
                      context.push('/chat', extra: friend);
                    },
                  );
                },
              );
            } else if (state is ContactsError) {
               return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Something went wrong'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddFriendDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
