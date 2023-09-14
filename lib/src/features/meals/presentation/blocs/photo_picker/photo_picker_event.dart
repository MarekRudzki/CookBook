part of 'photo_picker_bloc.dart';

class PhotoPickerEvent extends Equatable {
  const PhotoPickerEvent();

  @override
  List<Object> get props => [];
}

class SetImageFile extends PhotoPickerEvent {
  final File imageFile;
  final PhotoType selectedPhotoType;

  SetImageFile({
    required this.imageFile,
    required this.selectedPhotoType,
  });

  @override
  List<Object> get props => [
        imageFile,
        selectedPhotoType,
      ];
}

class SetImageUrl extends PhotoPickerEvent {
  final String imageUrl;
  final bool isSaveMode;

  SetImageUrl({required this.imageUrl, this.isSaveMode = true});

  @override
  List<Object> get props => [
        imageUrl,
        isSaveMode,
      ];
}

class RemovePhotoPressed extends PhotoPickerEvent {}
