import 'package:hive_flutter/hive_flutter.dart';

import '../models/measurement_model.dart';
import '../models/plot_model.dart';
import '../models/sync_queue_model.dart';
import '../models/user_profile_model.dart';

class HiveService {
  static const String plotsBox = 'plots';
  static const String measurementsBox = 'measurements';
  static const String syncQueueBox = 'sync_queue';
  static const String userProfileBox = 'user_profile';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserProfileModelAdapter());
    Hive.registerAdapter(PlotModelAdapter());
    Hive.registerAdapter(MeasurementModelAdapter());
    Hive.registerAdapter(SyncQueueModelAdapter());

    await Hive.openBox<UserProfileModel>(userProfileBox);
    await Hive.openBox<PlotModel>(plotsBox);
    await Hive.openBox<MeasurementModel>(measurementsBox);
    await Hive.openBox<SyncQueueModel>(syncQueueBox);
  }

  static Box<PlotModel> get plots => Hive.box<PlotModel>(plotsBox);
  static Box<MeasurementModel> get measurements =>
      Hive.box<MeasurementModel>(measurementsBox);
  static Box<SyncQueueModel> get syncQueue =>
      Hive.box<SyncQueueModel>(syncQueueBox);
  static Box<UserProfileModel> get userProfile =>
      Hive.box<UserProfileModel>(userProfileBox);
}
