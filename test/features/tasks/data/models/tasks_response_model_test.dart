import 'package:flutter_test/flutter_test.dart';
import 'package:workwise/features/tasks/data/models/tasks_response_model.dart';

void main() {
  group('TasksResponseModel', () {
    test('should parse correctly when links is missing from pagination', () {
      final json = <String, dynamic>{
        'success': true,
        'message': 'Tasks retrieved successfully.',
        'data': {
          'current_page': 1,
          'data': [
            {
              'id': 1,
              'title': 'Complete API Documentation',
              'description': 'Complete the OpenAPI documentation.',
              'priority': 'High',
              'status': 'In Progress',
              'progress': 60,
              'created_by': 2,
              'deadline': '2026-09-30T18:00:00.000000Z',
              'created_at': '2026-09-20T10:00:00.000000Z',
              'updated_at': '2026-09-23T10:00:00.000000Z',
            }
          ],
          'first_page_url': 'http://localhost/api/tasks?page=1',
          'from': 1,
          'last_page': 1,
          'last_page_url': 'http://localhost/api/tasks?page=1',
          'next_page_url': null,
          'path': 'http://localhost/api/tasks',
          'per_page': 15,
          'prev_page_url': null,
          'to': 1,
          'total': 1,
        },
      };

      final model = TasksResponseModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.message, 'Tasks retrieved successfully.');
      expect(model.data.tasks.length, 1);
      expect(model.data.tasks.first.id, 1);
      expect(model.data.tasks.first.title, 'Complete API Documentation');
      expect(model.data.links, isEmpty);
      expect(model.data.currentPage, 1);
      expect(model.data.lastPage, 1);
      expect(model.data.total, 1);
    });

    test('should parse safely when types are string or created_by is a Map', () {
      final json = <String, dynamic>{
        'success': 1,
        'message': 'Tasks retrieved successfully.',
        'data': {
          'current_page': '1',
          'data': [
            {
              'id': '42',
              'title': 'Task with object manager',
              'description': null,
              'priority': 'Medium',
              'status': 'Pending',
              'progress': '75',
              'created_by': {'id': 5, 'name': 'Manager Name'},
              'deadline': '2026-10-15',
              'created_at': '2026-10-01',
              'updated_at': '2026-10-02',
            }
          ],
          'last_page': '3',
          'per_page': '10',
          'total': '30',
        },
      };

      final model = TasksResponseModel.fromJson(json);

      expect(model.success, isTrue);
      expect(model.data.tasks.length, 1);
      expect(model.data.tasks.first.id, 42);
      expect(model.data.tasks.first.progress, 75);
      expect(model.data.tasks.first.createdBy, 5);
      expect(model.data.tasks.first.description, '');
      expect(model.data.currentPage, 1);
      expect(model.data.lastPage, 3);
      expect(model.data.perPage, 10);
      expect(model.data.total, 30);
    });
  });
}

