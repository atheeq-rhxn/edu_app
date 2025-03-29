import 'package:edu_app/features/course/cubit/course_cubit.dart';
import 'package:edu_app/features/course/cubit/course_state.dart';
import 'package:edu_app/features/course/views/screens/course_page.dart';
import 'package:edu_app/shared/widgets/carousel_widget.dart';
import 'package:edu_app/shared/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCarouselView extends StatefulWidget {
  const CourseCarouselView({super.key});

  @override
  State<CourseCarouselView> createState() => _CourseCarouselViewState();
}

class _CourseCarouselViewState extends State<CourseCarouselView> {
  @override
  void initState() {
    super.initState();
    context.read<CourseCubit>().fetchAllCourses();
  }

  Widget _buildCarousel(List courses) {
    return CarouselWidget(
      items: List.generate(
        courses.length,
        (index) => CourseCard(name: courses[index].name),
      ),
      onTap: (index) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CoursePage(courseId: courses[index].id),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CourseError) {
          return Center(
            child: Text('Failed to load courses: ${state.message}'),
          );
        } else if (state is CourseLoaded) {
          return _buildCarousel(state.courses);
        } else if (state is CourseDetailLoaded) {
          final lastState = context.read<CourseCubit>().lastLoadedState;
          if (lastState is CourseLoaded) {
            return _buildCarousel(lastState.courses);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}
