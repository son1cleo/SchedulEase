import 'package:flutter/material.dart';
import 'package:client/responsive.dart';

class SmartSchedulingScreen extends StatefulWidget {
  @override
  _SmartSchedulingScreenState createState() => _SmartSchedulingScreenState();
}

class _SmartSchedulingScreenState extends State<SmartSchedulingScreen> {
  int taskIdCounter = 1;
  int checklistItemIdCounter = 1;

  List<Map<String, dynamic>> tasks = [
    {
      'id': 1,
      'title': 'Grocery Shopping',
      'type': 'Checklist',
      'details': [
        {'id': 1, 'item': 'Buy Milk', 'completed': false},
        {'id': 2, 'item': 'Buy Bread', 'completed': false},
        {'id': 3, 'item': 'Buy Eggs', 'completed': true},
      ],
      'schedule_date': '2024-11-20',
      'schedule_time': ['16:00'],
      'status': 'To-do',
    },
    {
      'id': 2,
      'title': 'Complete Homework',
      'type': 'Description',
      'details': 'Math homework for chapter 5',
      'schedule_date': '2024-11-17',
      'schedule_time': ['10:00', '14:00'],
      'status': 'Overdue',
    },
  ];

  String searchQuery = "";
  String filterStatus = "All";

  @override
  void initState() {
    super.initState();
    _checkForOverdueTasks();
  }

  void _checkForOverdueTasks() {
    final now = DateTime.now();
    setState(() {
      for (var task in tasks) {
        final scheduleDate = DateTime.parse(task['schedule_date']);
        if (scheduleDate.isBefore(now) && task['status'] != 'Completed') {
          task['status'] = 'Overdue';
        }
      }
    });
  }

  void _showTaskDetails(Map<String, dynamic> task) {
    bool changesMade = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Automatically mark task as Completed if all checklist items are checked
            if (task['type'] == 'Checklist' &&
                (task['details'] as List<Map<String, dynamic>>)
                    .every((item) => item['completed'] == true) &&
                task['status'] != 'Completed') {
              setDialogState(() {
                task['status'] = 'Completed';
                changesMade = true; // Trigger the "Update" button
              });
            }

            return AlertDialog(
              title: Text(task['title']),
              content: task['type'] == 'Checklist'
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...((task['details'] as List<Map<String, dynamic>>)
                            .map<Widget>((item) {
                          return CheckboxListTile(
                            title: Text(item['item'].toString()),
                            value: item['completed'] as bool,
                            onChanged: task['status'] == 'Completed'
                                ? null
                                : (value) {
                                    setDialogState(() {
                                      item['completed'] = value!;
                                      changesMade = true;

                                      // Check if all checklist items are completed
                                      if ((task['details']
                                              as List<Map<String, dynamic>>)
                                          .every((item) =>
                                              item['completed'] == true)) {
                                        task['status'] = 'Completed';
                                      }
                                    });
                                  },
                          );
                        }).toList()),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Description: ${task['details']}'),
                        Text('Scheduled Date: ${task['schedule_date']}'),
                        Text(
                            'Scheduled Times: ${task['schedule_time'].join(', ')}'),
                        Text('Status: ${task['status']}'),
                      ],
                    ),
              actions: [
                if (task['type'] == 'Checklist' &&
                    changesMade &&
                    task['status'] != 'Completed')
                  TextButton(
                    onPressed: () {
                      setDialogState(() {
                        changesMade = false;
                        // Mark task as completed if all items are checked
                        if ((task['details'] as List<Map<String, dynamic>>)
                            .every((item) => item['completed'] == true)) {
                          task['status'] = 'Completed';
                        }
                      });

                      Navigator.pop(dialogContext);
                      setState(() {}); // Update parent state
                    },
                    child: Text('Update'),
                  ),
                if (task['status'] != 'Completed')
                  TextButton(
                    onPressed: () {
                      setDialogState(() {
                        task['status'] = 'Completed';
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task marked as Completed!')),
                      );

                      Navigator.pop(dialogContext);
                      setState(() {}); // Update parent state
                    },
                    child: Text('Complete'),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      tasks.remove(task);
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Refresh parent widget state after dialog is dismissed
      setState(() {});
    });
  }

  void _createTask() {
    final _formKey = GlobalKey<FormState>();
    String? title;
    String? type;
    String? description;
    List<String> checklist = [];
    String? scheduleDate;
    List<String> scheduleTimes = [];
    List<String> availableTimes = List.generate(24, (index) => '${index}:00');

    List<String> _getAvailableTimes(String date) {
      // Filter out times already scheduled for the selected date
      final scheduledTimes = tasks
          .where((task) => task['schedule_date'] == date)
          .expand((task) => task['schedule_time'])
          .toList();
      return availableTimes
          .where((time) => !scheduledTimes.contains(time))
          .toList();
    }

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
                      // Title Field
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Title'),
                        onChanged: (value) => title = value,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Title is required'
                            : null,
                      ),
                      // Type Dropdown
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
                      // Description or Checklist Fields
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
                              },
                            ),
                          ],
                        ),
                      // Schedule Date Picker
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
                              // Update available times for the selected date
                              availableTimes =
                                  _getAvailableTimes(scheduleDate!);
                            });
                          }
                        },
                        validator: (value) =>
                            scheduleDate == null ? 'Date is required' : null,
                      ),
                      // Time Selection Chips
                      if (scheduleDate != null)
                        Wrap(
                          children: availableTimes.map((time) {
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
                          }).toList(),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        scheduleTimes.isNotEmpty) {
                      // Add Task to List
                      setState(() {
                        tasks.add({
                          'id': taskIdCounter++,
                          'title': title,
                          'type': type,
                          'details':
                              type == 'Description' ? description : checklist,
                          'schedule_date': scheduleDate,
                          'schedule_time': scheduleTimes,
                          'status': 'To-do',
                        });
                      });
                      Navigator.pop(context); // Close Dialog
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

  List<Map<String, dynamic>> _filteredTasks() {
    return tasks.where((task) {
      final matchesSearch =
          task['title'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = filterStatus == "All" ||
          task['status'].toLowerCase() == filterStatus.toLowerCase();

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Widget _buildTaskGrid(BuildContext context, int crossAxisCount) {
    final filteredTasks = _filteredTasks();
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
                labelText: 'Search by title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
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
}
