import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:cookbook/src/core/enums.dart';
import 'package:cookbook/src/features/meals/presentation/blocs/photo_picker/photo_picker_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PhotoPickerBloc sut;

  final File testFile = File('path');

  setUp(() {
    sut = PhotoPickerBloc();
  });

  group('Photo Picker Bloc', () {
    blocTest<PhotoPickerBloc, PhotoPickerState>(
      'emits [PhotoPickerError] when SetImageUrl is added and url is empty.',
      build: () => sut,
      act: (bloc) => bloc.add(SetImageUrl(imageUrl: '')),
      expect: () => [
        PhotoPickerLoading(),
        PhotoPickerError(errorMessage: 'Field is empty'),
      ],
    );

    blocTest<PhotoPickerBloc, PhotoPickerState>(
      'emits [FileLoaded] when SetImageFile is added.',
      build: () => sut,
      act: (bloc) => bloc.add(SetImageFile(
          imageFile: testFile, selectedPhotoType: PhotoType.camera)),
      expect: () => [
        FileLoaded(selectedPhotoType: PhotoType.camera, imageFile: testFile),
      ],
    );

    blocTest<PhotoPickerBloc, PhotoPickerState>(
      'emits [PhotoPickerInitial] when RemovePhotoPressed is added.',
      build: () => PhotoPickerBloc(),
      act: (bloc) => bloc.add(RemovePhotoPressed()),
      expect: () => [PhotoPickerInitial()],
    );
  });
}
