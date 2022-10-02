
import 'package:um/domain/model/system/system.dart';
import 'package:um/domain/model/system/param.dart';

abstract class SystemRepository {

  Future<List<System>> getSystems();

  Future<System> createSystem(CreateParam param);

  Future<System> getSystemById(String systemId);

  Future<System> updateSystemById(UpdateSystemParam param);

  Future<System> removeSystemById(String systemId);

}
