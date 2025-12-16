import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object> get props => [];
}

class ContactsLoadFriends extends ContactsEvent {
  final String currentUserId;
  const ContactsLoadFriends(this.currentUserId);
}

class ContactsSearchUser extends ContactsEvent {
  final String username;
  const ContactsSearchUser(this.username);
}

class ContactsAddFriend extends ContactsEvent {
  final String currentUserId;
  final User friend;
  const ContactsAddFriend(this.currentUserId, this.friend);
}
