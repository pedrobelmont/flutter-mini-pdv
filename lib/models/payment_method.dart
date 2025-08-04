
import 'package:hive_ce/hive.dart';

part 'payment_method.g.dart';

@HiveType(typeId: 6)
enum PaymentMethod {
  @HiveField(0)
  pix,
  @HiveField(1)
  dinheiro,
  @HiveField(2)
  credito,
  @HiveField(3)
  debito,
}
