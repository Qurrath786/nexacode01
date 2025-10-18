void _handleCommand(String input) async {
  final output = await handleCommand(input);
  setState(() => feedback = output);
  _commandController.clear();
}

  void _navigateHistory(bool up) {
    if (commandHistory.isEmpty) return;

    setState(() {
      if (up) {
        historyIndex = (historyIndex + 1).clamp(0, commandHistory.length - 1);
      } else {
        historyIndex = (historyIndex - 1).clamp(0, commandHistory.length - 1);
      }
      _commandController.text = commandHistory[historyIndex];
      _commandController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commandController.text.length),
      );
    });
  }

  Widget _buildBootScreen() {
    return const Center(
      child: Text(
        '>> Booting NexaCode...',
        style: TextStyle(
          fontSize: 18,
          color: Colors.greenAccent,
          fontFamily: 'FiraCode',
          shadows: [Shadow(color: Colors.greenAccent, blurRadius: 12)],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: showBoot
            ? _buildBootScreen()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feedback,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.greenAccent,
                        fontFamily: 'FiraCode',
                        shadows: [Shadow(color: Colors.green, blurRadius: 8)],
                      ),
                    ),
                    const SizedBox(height: 20),
                    RawKeyboardListener(
                      focusNode: _focusNode,
                      onKey: (event) {
                        if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                          _navigateHistory(true);
                        } else if (event.isKeyPressed(
                          LogicalKeyboardKey.arrowDown,
                        )) {
                          _navigateHistory(false);
                        }
                      },
                      child: TextField(
                        controller: _commandController,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: 'FiraCode',
                        ),
                        cursorColor: Colors.greenAccent,
                        decoration: InputDecoration(
                          hintText: showCursor
                              ? 'nexacode@web:~\$ Type a command _'
                              : 'nexacode@web:~\$ Type a command  ',
                          hintStyle: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'FiraCode',
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent),
                          ),
                        ),
                        onSubmitted: _handleCommand,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: suggestions.map((s) {
                        return ActionChip(
                          label: Text(
                            s,
                            style: const TextStyle(
                              fontFamily: 'FiraCode',
                              color: Colors.black,
                            ),
                          ),
                          backgroundColor: Colors.greenAccent,
                          onPressed: () => _handleCommand(s),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: modules.map((module) {
                        return GestureDetector(
                          onTap: () {
                            if (module['label'] == 'Logout') {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacementNamed(
                                context,
                                module['route'],
                              );
                            } else {
                              Navigator.pushNamed(context, module['route']);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.greenAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.greenAccent.withOpacity(0.6),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  module['icon'],
                                  color: Colors.greenAccent,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  module['label'],
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontFamily: 'FiraCode',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
