import 'package:dartz/dartz.dart';
import 'package:demo_pinpad/src/features/agnostiko/data/datasources/sdk_data_source.dart';
import 'package:demo_pinpad/src/features/agnostiko/domain/repository/sdk_repository.dart';
import 'package:demo_pinpad/src/core/error/exception.dart';
import 'package:demo_pinpad/src/core/error/failure.dart';
import 'package:demo_pinpad/src/core/utils/typedef.dart';

class SDKRepositoryImpl implements SDKRepository {
  final SDKDataSource _dataSourceInitializer;

  SDKRepositoryImpl(this._dataSourceInitializer);

  @override
  ResultParams<void> initPos() async {
    try {
      await _dataSourceInitializer.initPos();
      return const Right(null);
    } on SDKException catch (e) {
      return Left(SDKFailure(
        message: e.message,
        errorCode: e.errorCode,
      ));
    }
  }

  @override
  ResultParams<void> loadServerCertificate() async {
    try {
      await _dataSourceInitializer.loadServerCertificate();
      return const Right(null);
    } on SDKException catch (e) {
      return Left(SDKFailure(
        message: e.message,
        errorCode: e.errorCode,
      ));
    }
  }
}
