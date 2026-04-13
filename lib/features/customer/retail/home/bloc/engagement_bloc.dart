import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treelove/common/models/blog_model.dart';
import 'package:treelove/common/models/testimonial_model.dart';
import 'package:treelove/common/repositories/engagement_repository.dart';
import 'package:treelove/core/network/base_network_status.dart';

part 'engagement_event.dart';
part 'engagement_state.dart';

class EngagementBloc extends Bloc<EngagementEvent, EngagementState> {
  final EngagementRepository _repository = EngagementRepository();

  EngagementBloc() : super(EngagementInitial()) {
    on<FetchEngagementData>((event, emit) async {
      emit(EngagementLoading());

      final blogResult = await _repository.getBlogs();
      final testimonialResult = await _repository.getTestimonials();

      final blogs = blogResult.status == ApiStatus.success 
          ? (blogResult.response as BlogResponse).data 
          : null;
          
      final testimonials = testimonialResult.status == ApiStatus.success 
          ? (testimonialResult.response as TestimonialResponse).data 
          : null;

      if (blogs != null || testimonials != null) {
        emit(EngagementLoaded(
          blogs: blogs,
          testimonials: testimonials,
        ));
      } else {
        emit(EngagementError("Failed to fetch engagement data"));
      }
    });
  }
}
