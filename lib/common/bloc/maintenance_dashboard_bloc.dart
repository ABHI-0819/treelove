import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/models/maintenance_dashboard_model.dart';
import '../../../common/models/response.mode.dart';
import '../../../common/repositories/maintenance_dashboard_repository.dart';
import '../../../core/network/base_network_status.dart';
import '../../../core/utils/logger.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class MaintenanceDashboardEvent {}

class FetchMaintenanceDashboard extends MaintenanceDashboardEvent {
  final String projectId;
  final String? projectAreaId;
  FetchMaintenanceDashboard({required this.projectId, this.projectAreaId});
}

// ─── States ──────────────────────────────────────────────────────────────────

abstract class MaintenanceDashboardState {}

class MaintenanceDashboardInitial extends MaintenanceDashboardState {}

class MaintenanceDashboardLoading extends MaintenanceDashboardState {}

class MaintenanceDashboardSuccess extends MaintenanceDashboardState {
  final MaintenanceDashboardModel data;
  MaintenanceDashboardSuccess(this.data);
}

class MaintenanceDashboardFailure extends MaintenanceDashboardState {
  final String message;
  MaintenanceDashboardFailure(this.message);
}

// ─── BLoC ────────────────────────────────────────────────────────────────────

class MaintenanceDashboardBloc
    extends Bloc<MaintenanceDashboardEvent, MaintenanceDashboardState> {
  final MaintenanceDashboardRepository repository;

  MaintenanceDashboardBloc(this.repository)
      : super(MaintenanceDashboardInitial()) {
    on<FetchMaintenanceDashboard>(_onFetch);
  }

  Future<void> _onFetch(
    FetchMaintenanceDashboard event,
    Emitter<MaintenanceDashboardState> emit,
  ) async {
    emit(MaintenanceDashboardLoading());
    try {
      final result = await repository.fetchMaintenanceDashboard(
        projectId: event.projectId,
        projectAreaId: event.projectAreaId,
      );
      switch (result.status) {
        case ApiStatus.success:
          emit(MaintenanceDashboardSuccess(result.response));
          break;
        default:
          final msg = (result.response is ResponseModel)
              ? (result.response as ResponseModel).message ?? 'Request failed'
              : 'Request failed';
          emit(MaintenanceDashboardFailure(msg));
      }
    } catch (e, stackTrace) {
      debugLog(e.toString(),
          name: "MaintenanceDashboardBloc",
          stackTrace: stackTrace);
      emit(MaintenanceDashboardFailure('Something went wrong.'));
    }
  }
}
