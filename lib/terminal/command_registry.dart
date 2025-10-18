import 'commands/save_command.dart';
import 'commands/ls_command.dart';
import 'commands/cat_command.dart';

final commandMap = {
  'save': SaveCommand.execute,
  'ls': LsCommand.execute,
  'cat': CatCommand.execute,
};
