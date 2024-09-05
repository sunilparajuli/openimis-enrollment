
import '../../../local/base/i_entity.dart';

abstract class IRootRepository<T> {
  Future<T> fetchConfig();
}
