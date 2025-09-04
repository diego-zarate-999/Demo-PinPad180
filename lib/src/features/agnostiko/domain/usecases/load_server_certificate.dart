import 'package:demo_pinpad/src/features/agnostiko/domain/repository/sdk_repository.dart';
import 'package:demo_pinpad/src/core/utils/typedef.dart';
import 'package:demo_pinpad/src/core/utils/usecase.dart';

class LoadServerCertificate extends UseCaseWithoutParams<void> {
  final SDKRepository _initializerRepository;

  LoadServerCertificate(this._initializerRepository);

  @override
  ResultParams<void> call() {
    return _initializerRepository.loadServerCertificate();
  }
}
