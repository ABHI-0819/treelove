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
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                          style: TextStyle(fontSize: 16,color: AppColor.black ,fontWeight: FontWeight.bold)
                        // style: const TextStyle(color: AppColor.primary),
                      ),
                      TextSpan(
                        text: "*",
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                MultiSelectSearchableDropdown<TreeDisease>(
                  items: treeDisease,
                  itemAsString: (disease) => disease.diseaseName,
                  searchableAttributes: (disease) => [disease.diseaseName!],
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
}
