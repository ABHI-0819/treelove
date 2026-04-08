import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/bloc/api_event.dart';
import '../../common/bloc/api_state.dart';
import '../../common/models/response.mode.dart';
import '../../common/repositories/tree_diseases_repository.dart';
import '../../features/fieldworker/activity/bloc/tree_diseases_bloc.dart';
import '../../features/fieldworker/activity/models/tree_diseases_list_response_model.dart';
import '../config/themes/app_color.dart';
import '../network/api_connection.dart';
import 'multi_select_searchable_dropdown.dart';

class CommonTreeDiseasesWidget extends StatelessWidget {
  final String title;
  final String hintText;
  final String searchHintText;
  final void Function(List<TreeDisease>)? onChanged;

  const CommonTreeDiseasesWidget({
    super.key,
    this.title = "Tree Diseases",
    this.hintText = "Select Diseases",
    this.searchHintText = "Search Diseases...",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TreeDiseasesBloc>(
      create: (_) => TreeDiseasesBloc(
        TreeDiseasesRepository(api: ApiConnection()), // 👈 create inside
      )..add(ApiListFetch()), // fire initial event if needed
      child: BlocBuilder<TreeDiseasesBloc,
          ApiState<TreeDiseaseListResponse, ResponseModel>>(
        builder: (context, state) {
          if (state is ApiLoading<TreeDiseaseListResponse, ResponseModel>) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ApiSuccess<TreeDiseaseListResponse, ResponseModel>) {
            final treeDisease = state.data.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOptionalSectionHeader(
                  title: 'Tree Diseases',
                  subtitle: 'Select if any disease is observed',
                ),
                const SizedBox(height: 5),
                MultiSelectSearchableDropdown<TreeDisease>(
                  items: treeDisease,
                  itemAsString: (disease) => disease.diseaseName,
                  searchableAttributes: (disease) => [disease.diseaseName],
                  hintText: hintText,
                  searchHintText: searchHintText,
                  onChanged: onChanged,
                ),
              ],
            );
          }

          if (state is ApiFailure<TreeDiseaseListResponse, ResponseModel>) {
            return Text("Error: ${state.error}");
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _sectionLabel({
    required String title,
    required bool mandatory,
    String? subtitle,
    bool hasError = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: hasError ? Colors.red.shade700 : const Color(0xFF1A1A1A),
              ),
            ),
            if (mandatory) ...[
              const SizedBox(width: 2),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: hasError ? Colors.red.shade700 : Colors.red,
                  height: 1.1,
                ),
              ),
            ] else ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'Optional',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
        // Inline "required" error text
        if (hasError) ...[
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(Icons.error_outline, size: 12, color: Colors.red.shade500),
              const SizedBox(width: 4),
              Text(
                'This field is required',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOptionalSectionHeader({
    required String title,
    String? subtitle,
  }) {
    return _sectionLabel(
      title: title,
      mandatory: false,
      subtitle: subtitle,
    );
  }
}
