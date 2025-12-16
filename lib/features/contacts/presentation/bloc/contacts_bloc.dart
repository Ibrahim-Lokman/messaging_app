import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../../../auth/domain/entities/user.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactsRepository contactsRepository;
  StreamSubscription? _friendsSubscription;

  ContactsBloc({required this.contactsRepository}) : super(ContactsInitial()) {
    on<ContactsLoadFriends>(_onLoadFriends);
    on<ContactsSearchUser>(_onSearchUser);
    on<ContactsAddFriend>(_onAddFriend);
    on<_ContactsUpdated>((event, emit) {
      emit(ContactsLoaded(
        friends: event.friends,
        searchResult: state is ContactsLoaded ? (state as ContactsLoaded).searchResult : null,
      ));
    });
  }

  Future<void> _onLoadFriends(
    ContactsLoadFriends event,
    Emitter<ContactsState> emit,
  ) async {
    emit(ContactsLoading());
    await _friendsSubscription?.cancel();
    _friendsSubscription = contactsRepository
        .getFriends(event.currentUserId)
        .listen((friends) {
      add(_ContactsUpdated(friends));
    });
  }
  
  // Private API to bridge Stream -> State
  // We need to register this handler too.
  // Actually, let's register generic handler first.
  
  Future<void> _onSearchUser(
    ContactsSearchUser event,
    Emitter<ContactsState> emit,
  ) async {
    final currentState = state;
    List<dynamic> currentFriends = [];
    if (currentState is ContactsLoaded) {
      currentFriends = currentState.friends;
    }

    try {
      final user = await contactsRepository.searchUserByUsername(event.username);
      emit(ContactsLoaded(
        friends: currentState is ContactsLoaded ? currentState.friends : [],
        searchResult: user,
        error: user == null ? 'User not found' : null,
      ));
    } catch (e) {
      emit(ContactsLoaded(
        friends: currentState is ContactsLoaded ? currentState.friends : [],
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAddFriend(
    ContactsAddFriend event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      await contactsRepository.addFriend(event.currentUserId, event.friend.uid);
      // The stream will update the friends list automatically
      // We might want to clear search result
      emit(ContactsLoaded(
        friends: state is ContactsLoaded ? (state as ContactsLoaded).friends : [],
        searchResult: null, 
        error: null,
      ));
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _friendsSubscription?.cancel();
    return super.close();
  }
}

// Internal event helper
class _ContactsUpdated extends ContactsEvent {
  final List<User> friends; 
  const _ContactsUpdated(this.friends);
}
