import '/features/course/views/widgets/professor_widget.dart';
import '/features/course/views/widgets/modules_widget.dart';
import '/features/course/views/widgets/quiz_widget.dart';
import '/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '/features/course/models/course_model.dart';

class CoursePage extends StatelessWidget {
  final Course course;

  const CoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: course.name),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProfessorWidget(professor: course.professor),
          const SizedBox(height: 24),
          QuizWidget(quizzes: course.quizzes),
          const SizedBox(height: 24),
          ModulesWidget(course: course),
        ],
      ),
    );
  }
}
