import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings_cubit.dart';
import '../widgets/add_script_dialog.dart';
import '../widgets/remove_script_confirmation.dart';
import '../widgets/script_output.dart';
import 'settings_page.dart';

class ScriptRunnerHome extends StatefulWidget {
  @override
  _ScriptRunnerHomeState createState() => _ScriptRunnerHomeState();
}

class _ScriptRunnerHomeState extends State<ScriptRunnerHome>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, String>> scripts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to add a new script
  Future<void> _addScript() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AddScriptDialog(),
    );

    if (result != null) {
      setState(() {
        scripts.add(result);
        _tabController = TabController(length: scripts.length, vsync: this);
      });
    }
  }

  // Function to remove a script
  void _removeScript(int index) {
    showDialog(
      context: context,
      builder: (context) => RemoveScriptConfirmation(
        onConfirm: () {
          setState(() {
            scripts.removeAt(index);
            _tabController = TabController(length: scripts.length, vsync: this);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Watchdog',
              style: TextStyle(
                fontSize: settingsState.fontSize + 10, // Adjust title size
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add,
                ), // Larger add icon
                onPressed: _addScript,
                tooltip: 'Add Script',
              ),
              IconButton(
                icon: Icon(Icons.settings), // Larger settings icon
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
                tooltip: 'Settings',
              ),
            ],
          ),
          body: scripts.isEmpty
              ? Center(
                  child: Text(
                    'No scripts added. Click the + icon to add scripts.',
                    style: TextStyle(
                      fontSize: settingsState.fontSize, // Adjust body text size
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    // Add vertical space between AppBar and TabBar
                    SizedBox(height: 20), // Adjust this value as needed

                    // TabBar for scripts
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: scripts
                          .map((script) => Tab(
                                child: Text(
                                  script['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: settingsState
                                        .fontSize, // Adjust tab font size
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: scripts.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, String> script = entry.value;
                          return ScriptOutput(
                            path: script['path'] ?? '',
                            onDelete: () => _removeScript(index),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
