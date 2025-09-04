import 'package:demo_pinpad/src/core/utils/typedef.dart';

abstract class SDKRepository {
  ResultParams<void> loadServerCertificate();
  ResultParams<void> initPos();
}
