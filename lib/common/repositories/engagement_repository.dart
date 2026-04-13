import 'package:treelove/common/models/blog_model.dart';
import 'package:treelove/common/models/testimonial_model.dart';
import 'package:treelove/core/network/api_connection.dart';
import 'package:treelove/core/network/base_network.dart';
import 'package:treelove/core/network/base_network_status.dart';

class EngagementRepository {
  final ApiConnection _apiConnection = ApiConnection();

  Future<ApiResult> getBlogs() async {
    return await _apiConnection.getApiConnection<BlogResponse>(
      BaseNetwork.trendingTopicURL,
      BaseNetwork.getJsonHeaders(),
      blogResponseFromJson,
    );
  }

  Future<ApiResult> getTestimonials() async {
    return await _apiConnection.getApiConnection<TestimonialResponse>(
      BaseNetwork.testimonialsURL,
      BaseNetwork.getJsonHeaders(),
      testimonialResponseFromJson,
    );
  }
}
