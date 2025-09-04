import 'package:demo_pinpad/src/features/agnostiko/domain/repository/sdk_repository.dart';
import 'package:demo_pinpad/src/core/utils/typedef.dart';
import 'package:demo_pinpad/src/core/utils/usecase.dart';

class InitPOS extends UseCaseWithoutParams<void> {
  final SDKRepository _initializerRepository;

  InitPOS(this._initializerRepository);

  @override
  ResultVoid call() async => _initializerRepository.initPos();
}
