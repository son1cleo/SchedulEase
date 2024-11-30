import 'package:flutter/material.dart';
import 'package:client/responsive.dart';
import 'package:client/services/task_service.dart'; // Import the service file
import 'package:client/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SmartSchedulingScreen extends StatefulWidget {
  @override
  _SmartSchedulingScreenState createState() => _SmartSchedulingScreenState();
}

class _SmartSchedulingScreenState extends State<SmartSchedulingScreen> {
  late TaskService taskService;
  List<Map<String, dynamic>> tasks = [];
  String searchQuery = "";
  String filterStatus = "All";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      taskService = TaskService(userProvider: userProvider);
      _fetchTasks();
    });
  }

  void _fetchTasks() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.userId;

      if (userId == null || userId.isEmpty) {
        throw Exception("User is not authenticated.");
      }

      final fetchedTasks = await taskService.getTasks(userId);
      setState(() {
        tasks = fetchedTasks;
      });
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  // Show task details in a modal bottom sheet
  void _showTaskDetails(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Type: ${task['type']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    if (task['type'] == 'Description')
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Details: ${task['details']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    if (task['type'] == 'Checklist')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text('Checklist:', style: TextStyle(fontSize: 16)),
                          ...List.generate(
                            task['details'].length,
                            (index) {
                              final item = task['details'][index];
                              final isCompleted = item['completed'] == true;

                              return Row(
                                children: [
                                  Checkbox(
                                    value: isCompleted,
                                    onChanged: (task['status'] == 'Completed')
                                        ? null
                                        : (bool? value) async {
                                            try {
                                              setState(() {
                                                item['completed'] = value;
                                              });

                                              // Update checklist in the backend
                                              final updatedDetails = List<
                                                      Map<String,
                                                          dynamic>>.from(
                                                  task['details']);
                                              updatedDetails[index]
                                                  ['completed'] = value;

                                              await taskService.updateTask(
                                                task['_id'],
                                                {
                                                  'details': updatedDetails,
                                                },
                                              );

                                              // Check if all items are completed
                                              final allCompleted =
                                                  updatedDetails.every(
                                                      (detail) =>
                                                          detail['completed'] ==
                                                          true);

                                              if (allCompleted) {
                                                // Update the task status to "Completed"
                                                await taskService.updateTask(
                                                  task['_id'],
                                                  {'status': 'Completed'},
                                                );
                                                setState(() {
                                                  task['status'] = 'Completed';
                                                });
                                                _fetchTasks();
                                              }
                                            } catch (e) {
                                              print(
                                                  "Error updating checklist item: $e");
                                            }
                                          },
                                  ),
                                  Text(item['item'] ?? '',
                                      style: TextStyle(fontSize: 16)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                    Text(
                      'Scheduled Date: ${task['schedule_date']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Scheduled Times: ${task['schedule_time'].join(', ')}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Status: ${task['status']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: task['status'] == 'Overdue'
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: (task['status'] == 'Completed')
                              ? null // Disable if already completed
                              : () {
                                  _updateTaskStatus(task, 'Completed');
                                  Navigator.pop(context);
                                },
                          child: Text('Mark as Completed'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            _deleteTask(task['_id']);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text('Delete Task'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Function to update task status
  void _updateTaskStatus(Map<String, dynamic> task, String status) async {
    try {
      final updatedTask = await taskService.updateTask(task['_id'], {
        'status': status,
      });
      setState(() {
        final index = tasks.indexWhere((t) => t['_id'] == updatedTask['_id']);
        if (index != -1) {
          tasks[index] = updatedTask;
        }
      });
      _fetchTasks();
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  // Function to delete task
  void _deleteTask(String id) async {
    try {
      await taskService.deleteTask(id);
      setState(() {
        tasks.removeWhere((task) => task['_id'] == id);
      });
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  // Build the task grid
  Widget _buildTaskGrid(BuildContext context, int crossAxisCount) {
    final filteredTasks = tasks.where((task) {
      final matchesSearch =
          task['title'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = filterStatus == "All" ||
          task['status'].toLowerCase() == filterStatus.toLowerCase();
      return matchesSearch && matchesFilter;
    }).toList();

    return filteredTasks.isNotEmpty
        ? GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return GestureDetector(
                onTap: () => _showTaskDetails(task),
                child: Card(
                  color: task['status'] == 'Completed'
                      ? Colors.green[100]
                      : Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task['title'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Date: ${task['schedule_date']}'),
                        Text('Times: ${task['schedule_time'].join(', ')}'),
                        Text('Status: ${task['status']}',
                            style: TextStyle(
                              color: task['status'] == 'Overdue'
                                  ? Colors.red
                                  : Colors.black,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Center(child: Text('No tasks found.'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Scheduling'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: filterStatus,
              icon: Icon(Icons.filter_list, color: Colors.white),
              dropdownColor: Colors.blue,
              items: ["All", "Completed", "To-do", "Overdue"]
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  filterStatus = value!;
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: Responsive(
              mobile: _buildTaskGrid(context, 1),
              tablet: _buildTaskGrid(context, 2),
              desktop: _buildTaskGrid(context, 3),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTask,
        child: Icon(Icons.add),
      ),
    );
  }

  void _createTask() {
    final _formKey = GlobalKey<FormState>();
    String? title;
    String? type;
    String? description;
    List<String> checklist = [];
    String? scheduleDate;
    List<String> scheduleTimes = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Create Task'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        onChanged: (value) => title = value,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Title is required'
                            : null,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Type'),
                        items: ['Description', 'Checklist']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            type = value;
                            if (type == 'Description') {
                              checklist.clear();
                            } else {
                              description = null;
                            }
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Type is required' : null,
                      ),
                      if (type == 'Description')
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          onChanged: (value) => description = value,
                          validator: (value) => type == 'Description' &&
                                  (value == null || value.isEmpty)
                              ? 'Description is required'
                              : null,
                        ),
                      if (type == 'Checklist')
                        Column(
                          children: [
                            ...checklist.map((item) => Row(
                                  children: [
                                    Expanded(child: Text(item)),
                                    IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      onPressed: () {
                                        setState(() {
                                          checklist.remove(item);
                                        });
                                      },
                                    ),
                                  ],
                                )),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Add Checklist Item'),
                              onFieldSubmitted: (value) {
                                setState(() {
                                  checklist.add(value);
                                });
                                _fetchTasks();
                                _fetchTasks();
                              },
                            ),
                          ],
                        ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Schedule Date',
                            hintText: 'Select a date'),
                        controller: TextEditingController(
                            text: scheduleDate != null ? scheduleDate : ''),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              scheduleDate =
                                  pickedDate.toIso8601String().split('T')[0];
                            });
                          }
                        },
                        validator: (value) =>
                            scheduleDate == null ? 'Date is required' : null,
                      ),
                      if (scheduleDate != null)
                        Wrap(
                          children: List.generate(
                            24,
                            (index) {
                              final time = '${index}:00';
                              return FilterChip(
                                label: Text(time),
                                selected: scheduleTimes.contains(time),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      scheduleTimes.add(time);
                                    } else {
                                      scheduleTimes.remove(time);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      if (scheduleTimes.isEmpty)
                        Text('Please select at least one time.',
                            style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        scheduleTimes.isNotEmpty) {
                      try {
                        final newTask = await taskService.createTask({
                          'title': title,
                          'type': type,
                          'details':
                              type == 'Description' ? description : checklist,
                          'schedule_date': scheduleDate,
                          'schedule_time': scheduleTimes,
                          'status': 'To-do',
                        });
                        setState(() {
                          tasks.add(newTask);
                        });
                        // Refresh tasks after successful creation
                        _fetchTasks();

                        Navigator.pop(context);
                      } catch (e) {
                        print("Error creating task: $e");
                      }
                    }
                  },
                  child: Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
