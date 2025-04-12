import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/src/core/entities/failure.dart';

///[Future].
mixin UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

///[Stream].
mixin StreamUseCases<T, Params> {
  Stream<T> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
