part of 'photo_picker_bloc.dart';

class PhotoPickerState extends Equatable {
  const PhotoPickerState();

  @override
  List<Object> get props => [];
}

class PhotoPickerInitial extends PhotoPickerState {}

class PhotoPickerLoading extends PhotoPickerState {}

class FileLoaded extends PhotoPickerState {
  final PhotoType selectedPhotoType;
  final File imageFile;

  FileLoaded({
    required this.selectedPhotoType,
    required this.imageFile,
  });

  @override
  List<Object> get props => [
        selectedPhotoType,
        imageFile,
      ];
}

class UrlLoaded extends PhotoPickerState {
  final String imageUrl;

  UrlLoaded({
    required this.imageUrl,
  });

  @override
  List<Object> get props => [
        imageUrl,
      ];
}

class PhotoPickerError extends PhotoPickerState {
  final String errorMessage;

  PhotoPickerError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
