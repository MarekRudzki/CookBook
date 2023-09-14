import 'dart:io';

import 'package:cookbook/src/core/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

part 'photo_picker_event.dart';
part 'photo_picker_state.dart';

@injectable
class PhotoPickerBloc extends Bloc<PhotoPickerEvent, PhotoPickerState> {
  PhotoPickerBloc() : super(PhotoPickerInitial()) {
    on<SetImageUrl>(_onSetImageUrl);
    on<SetImageFile>(_onSetImageFile);
    on<RemovePhotoPressed>(_onRemovePhotoPressed);
  }

  Future<void> _onSetImageUrl(
    SetImageUrl event,
    Emitter<PhotoPickerState> emit,
  ) async {
    emit(PhotoPickerLoading());
    if (event.imageUrl.isEmpty) {
      emit(PhotoPickerError(errorMessage: 'Field is empty'));
      return;
    }
    http.Response res;

    try {
      res = await http.get(
        Uri.parse(event.imageUrl),
      );
    } catch (error) {
      emit(PhotoPickerError(errorMessage: error.toString()));
      return;
    }
    if (res.statusCode != 200) {
      emit(PhotoPickerError(errorMessage: 'Provided URL is not valid'));
      return;
    }

    if (event.imageUrl.endsWith('.jpg') ||
        event.imageUrl.endsWith('.jpeg') ||
        event.imageUrl.endsWith('.png') ||
        !event.isSaveMode) {
      emit(UrlLoaded(
        imageUrl: event.imageUrl,
      ));
    } else {
      emit(PhotoPickerError(errorMessage: 'Provided URL is not valid'));
      return;
    }
  }

  void _onSetImageFile(
    SetImageFile event,
    Emitter<PhotoPickerState> emit,
  ) {
    emit(FileLoaded(
        selectedPhotoType: event.selectedPhotoType,
        imageFile: event.imageFile));
  }

  void _onRemovePhotoPressed(
    RemovePhotoPressed event,
    Emitter<PhotoPickerState> emit,
  ) {
    emit(PhotoPickerInitial());
  }
}
