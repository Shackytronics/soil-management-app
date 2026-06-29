import 'package:hive_flutter/hive_flutter.dart';

import '../models/measurement_model.dart';
import '../models/plot_model.dart';
import '../models/recommendation_model.dart';
import '../models/sync_queue_model.dart';
import '../models/user_profile_model.dart';

class HiveService {
  static const String plotsBox = 'plots';
  static const String measurementsBox = 'measurements';
  static const String syncQueueBox = 'sync_queue';
  static const String userProfileBox = 'user_profile';
  static const String recommendationsBox = 'recommendations';

  /// Untyped key/value box for lightweight app preferences (e.g. language).
  static const String appSettingsBox = 'app_settings';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserProfileModelAdapter());
    Hive.registerAdapter(PlotModelAdapter());
    Hive.registerAdapter(MeasurementModelAdapter());
    Hive.registerAdapter(SyncQueueModelAdapter());
    Hive.registerAdapter(RecommendationModelAdapter());
    Hive.registerAdapter(RecommendationItemAdapter());

    await Hive.openBox<UserProfileModel>(userProfileBox);
    await Hive.openBox<PlotModel>(plotsBox);
    await Hive.openBox<MeasurementModel>(measurementsBox);
    await Hive.openBox<SyncQueueModel>(syncQueueBox);
    await Hive.openBox<RecommendationModel>(recommendationsBox);
    await Hive.openBox<dynamic>(appSettingsBox);
  }

  static Box<PlotModel> get plots => Hive.box<PlotModel>(plotsBox);
  static Box<MeasurementModel> get measurements =>
      Hive.box<MeasurementModel>(measurementsBox);
  static Box<SyncQueueModel> get syncQueue =>
      Hive.box<SyncQueueModel>(syncQueueBox);
  static Box<UserProfileModel> get userProfile =>
      Hive.box<UserProfileModel>(userProfileBox);
  static Box<RecommendationModel> get recommendations =>
      Hive.box<RecommendationModel>(recommendationsBox);
  static Box<dynamic> get appSettings => Hive.box<dynamic>(appSettingsBox);
}
