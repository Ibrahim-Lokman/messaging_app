import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/profile.dart';
import '../../data/profile_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await repository.getProfile(event.userId);
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError('Failed to load profile'));
      }
    });
    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        await repository.updateProfile(event.profile);
        emit(ProfileLoaded(event.profile));
      } catch (e) {
        emit(ProfileError('Failed to update profile'));
      }
    });
  }
}
