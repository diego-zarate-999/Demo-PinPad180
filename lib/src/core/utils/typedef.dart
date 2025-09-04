import 'package:dartz/dartz.dart';
import 'package:demo_pinpad/src/core/error/failure.dart';

typedef ResultVoid = Future<Either<Failure, void>>;
typedef ResultParams<T> = Future<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
