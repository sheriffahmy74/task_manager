import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager/core/errors/failures.dart';
import 'package:task_manager/core/usecases/usecase.dart';
import 'package:task_manager/features/projects/domain/entities/project_entity.dart';
import 'package:task_manager/features/projects/domain/usecases/create_project_usecase.dart';
import 'package:task_manager/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:task_manager/features/projects/presentation/cubit/projects_cubit.dart';

class MockGetProjectsUseCase extends Mock implements GetProjectsUseCase {}

class MockCreateProjectUseCase extends Mock implements CreateProjectUseCase {}

void main() {
  late MockGetProjectsUseCase mockGetProjects;
  late MockCreateProjectUseCase mockCreateProject;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    mockGetProjects = MockGetProjectsUseCase();
    mockCreateProject = MockCreateProjectUseCase();
  });

  const projects = [
    ProjectEntity(
      id: '1',
      title: 'Test Project',
      description: 'A project',
      status: 'pending',
    ),
  ];

  group('ProjectsCubit', () {
    blocTest<ProjectsCubit, ProjectsState>(
      'emits [Loading, Loaded] when getProjects succeeds',
      build: () {
        when(() => mockGetProjects(any())).thenAnswer(
          (_) async => Right<Failure, List<ProjectEntity>>(projects),
        );
        return ProjectsCubit(mockGetProjects, mockCreateProject);
      },
      act: (cubit) => cubit.loadProjects(),
      expect: () => const [
        ProjectsLoading(),
        ProjectsLoaded(projects),
      ],
    );

    blocTest<ProjectsCubit, ProjectsState>(
      'emits [Loading, Error] when getProjects fails',
      build: () {
        when(() => mockGetProjects(any())).thenAnswer(
          (_) async => Left<Failure, List<ProjectEntity>>(
            const ServerFailure(message: 'Something went wrong'),
          ),
        );
        return ProjectsCubit(mockGetProjects, mockCreateProject);
      },
      act: (cubit) => cubit.loadProjects(),
      expect: () => const [
        ProjectsLoading(),
        ProjectsError('Something went wrong'),
      ],
    );
  });
}
