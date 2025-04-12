import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final T? data;
  final String? message;
  final bool? status;

  ApiResponse({this.data, this.message, this.status});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
