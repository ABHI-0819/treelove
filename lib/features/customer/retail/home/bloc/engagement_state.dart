part of 'engagement_bloc.dart';

abstract class EngagementState {}

class EngagementInitial extends EngagementState {}

class EngagementLoading extends EngagementState {}

class EngagementLoaded extends EngagementState {
  final List<BlogModel>? blogs;
  final List<TestimonialModel>? testimonials;

  EngagementLoaded({this.blogs, this.testimonials});
}

class EngagementError extends EngagementState {
  final String message;

  EngagementError(this.message);
}
