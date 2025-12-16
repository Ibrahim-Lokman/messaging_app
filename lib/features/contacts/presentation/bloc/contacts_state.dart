import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();
  
  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<User> friends;
  // We can include search result here or separate state
  final User? searchResult;
  final String? error;

  const ContactsLoaded({
    this.friends = const [],
    this.searchResult,
    this.error,
  });

  ContactsLoaded copyWith({
    List<User>? friends,
    User? searchResult,
    String? error,
  }) {
    // If searchResult is explicitly null passed (to clear), we need nullable logic
    // But copyWith usually ignores null. We'll handle 'clear' by passing a dummy or specific flag if needed.
    // For now, assuming if passed, update.
    return ContactsLoaded(
      friends: friends ?? this.friends,
      searchResult: searchResult, // Nullable update logic could be tricky here
      error: error,
    );
  }

  @override
  List<Object?> get props => [friends, searchResult, error];
}

class ContactsError extends ContactsState {
  final String message;
  const ContactsError(this.message);
}
