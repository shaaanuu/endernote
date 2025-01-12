part of 'sync_bloc.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

class SyncDirectoryToFirebase extends SyncEvent {}

class SyncFirebaseToDirectory extends SyncEvent {}
