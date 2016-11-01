(function(mod) {
  if (typeof exports == "object" && typeof module == "object") // CommonJS
    return mod(require("tern/lib/infer"), require("tern/lib/tern"));
  if (typeof define == "function" && define.amd) // AMD
    return define([ "tern/lib/infer", "tern/lib/tern" ], mod);
  mod(tern, tern);
})
(function(infer, tern) {
  "use strict";

  function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
  }

  function isGrunfile(filename) {
    return filename === "[doc]" || endsWith(filename, "Gruntfile.js");
  }

  function getTasks(filename) {
    var server = infer.cx().parent, data = server && server.mod.grunt, gruntFile = filename && data[filename];
    return gruntFile ? gruntFile.tasks : null;
  }

  infer.registerFunction("grunt_registerTask", function(self, args, argNodes) {
    var name = argNodes && argNodes[0] && argNodes[0].type == "Literal" && argNodes[0].value;
    if (typeof name == "string")
      getTasks(argNodes[0].sourceFile.name)[name] = {"node": argNodes[0]};
    return infer.ANull;
  });

  infer.registerFunction("grunt_initConfig", function(self, args, argNodes) {
    var server = infer.cx().parent, data = server && server.mod.grunt;
    if (argNodes && argNodes.length && argNodes[0].type == "ObjectExpression") {
      var filename = argNodes[0].sourceFile.name, tasks = getTasks(filename);
      if (tasks) {
        argNodes[0].properties.forEach(function(prop) {
          var key = prop.key.name || prop.key.value, value = prop.value, targets = {};
          if (value && value.type == "ObjectExpression") {
            value.properties.forEach(function(prop) {
              var key = prop.key.name || prop.key.value;
              if (key != "options") targets[key] = {"node": prop.key};
            });
          }
          tasks[key] = {"node": prop.key, "targets": targets};
        });
      }
    }
    return infer.ANull;
  });

  tern.registerPlugin("grunt", function(server, options) {
    server.mod.grunt = Object.create(null);
    server.on("afterLoad", afterLoad);
    server.on("preInfer", preInfer);
    server.addDefs(defs);
  });

  function afterLoad(file) {
    if (isGrunfile(file.name)) {
      var fnType = file.scope.exports && file.scope.exports.getFunctionType();
      if (fnType) {
        var cx = infer.cx(), deps = [cx.definitions.grunt.Grunt];
        fnType.propagate(new infer.IsCallee(infer.cx().topScope, deps, null, infer.Null));
      }
    }
  }

  function preInfer(ast, scope) {
    var filename = ast.sourceFile.name;
    if (isGrunfile(filename)) infer.cx().parent.mod.grunt[filename] = {tasks: Object.create(null)};
  }

  tern.defineQueryType("grunt-task", {
    takesFile: true,
    run: function(server, query, file) {
      try {
        var name = query.name, taskName = name, targetName = null, index = name.indexOf(":");
        if (index != -1) {
          taskName = taskName.substring(0, index);
          targetName = name.substring(index+1, name.length);
        }
        var filename = file.name, tasks = getTasks(filename), task = tasks ? tasks[taskName] : null;
        if (task) {
          if (targetName && task.targets) task = task.targets[targetName];
          var node = task && task.node;
          if (node && node.sourceFile) return {file: node.sourceFile.name, start: node.start, end: node.end};
        }
        return {};
      } catch(err) {
        console.error(err.stack);
        return {};
      }
    }
  });

  tern.defineQueryType("grunt-tasks", {
    takesFile: true,
    run: function(server, query, file) {
      try {
        var result = [], filename = file.name, tasks = getTasks(filename);
        if (tasks) {
          for(var name in tasks) {
            var task = tasks[name], targets = [];
            if (task.targets) {
              for(var targetName in task.targets) {
                targets.push({"name": targetName});
              }
            }
            result.push({"name": name, "targets": targets});
          }
        }
        return {"completions": result};
      } catch(err) {
        console.error(err.stack);
        return {};
      }
    }
  });

  var defs = {
    "!name" : "grunt",
    "!define" : {
      Grunt : {
        config: {
          "!doc": "Access project-specific configuration data defined in the Gruntfile.",
          "!url": "http://gruntjs.com/api/grunt.config",
          init: {
            "!type": "fn(configObject: ?)",
            "!doc": "Initialize a configuration object for the current project.\nThe specified configObject is used by tasks and can be accessed using the grunt.config method.\nNearly every project's Gruntfile will call this method.",
            "!url": "http://gruntjs.com/api/grunt.config#grunt.config.init",
            "!effects": ["custom grunt_initConfig"]
          },
          get: {
            "!type": "fn(prop?: ?) -> ?",
            "!doc": "Get a value from the project's Grunt configuration. If prop is specified, that property's value is returned, or null if that property is not defined. If prop isn't specified, a copy of the entire config object is returned. Templates strings will be recursively processed using the grunt.config.process method.",
            "!url": "http://gruntjs.com/api/grunt.config#grunt.config.get"
          },
          process: {
            "!type": "fn(value?: ?) -> ?",
            "!doc": "Process a value, recursively expanding <% %> templates (via the grunt.template.process method) in the context of the Grunt config, as they are encountered. this method is called automatically by grunt.config.get but not by grunt.config.getRaw.",
            "!url": "http://gruntjs.com/api/grunt.config#grunt.config.process"
          },
          getRaw: {
            "!type": "fn(value?: ?) -> ?",
            "!doc": "Get a raw value from the project's Grunt configuration, without processing <% %> template strings. If prop is specified, that property's value is returned, or null if that property is not defined. If prop isn't specified, a copy of the entire config object is returned.",
            "!url": "http://gruntjs.com/api/grunt.config#grunt.config.getRaw"
          },
          set: {
            "!type": "fn(prop: ?, value: ?) -> ?",
            "!doc": "Set a value into the project's Grunt configuration.",
            "!url": "http://gruntjs.com/api/grunt.config#grunt.config.set"
          },
          escape: {
            "!type": "fn(propString: string) -> string",
            "!doc": "Escape . dots in the given propString. This should be used for property names that contain dots.",
            "!url": "http://gruntjs.com/api/grunt.config#grunt.config.escape"
          },
          merge: {
            "!type": "fn(configObject: ?) -> ?",
            "!doc": "Recursively merges properties of the specified configObject into the current project configuration.",
            "!url": "http://gruntjs.com/api/grunt.config#grunt.config.merge"
          },
          requires: {
            "!type": "fn(prop: [string]) -> ?",
            "!doc": "Fail the current task if one or more required config properties is missing, null or undefined. One or more string or array config properties may be specified.",
            "!url": "http://gruntjs.com/api/grunt.config#grunt.config.requires"
          }
        },
        event: {
          "!doc": "Even though only the most relevant methods are listed on this page, the full EventEmitter2 API is available on the grunt.event object. Event namespaces may be specified with the . (dot) separator, and namespace wildcards have been enabled.",
          "!url": "http://gruntjs.com/api/grunt.event",
          on: {
            "!type": "fn(event: Event, listener: ?)",
            "!doc": "Adds a listener to the end of the listeners array for the specified event.",
            "!url": "http://gruntjs.com/api/grunt.event#grunt.event.on"
          },
          once: {
            "!type": "fn(event: Event, listener: ?)",
            "!doc": "Adds a one time listener for the event. The listener is invoked only the first time the event is fired, after which it is removed.",
            "!url": "http://gruntjs.com/api/grunt.event#grunt.event.once"
          },
          many: {
            "!type": "fn(event: Event, timesToListen: number, listener: ?)",
            "!doc": "Adds a listener that will execute n times for the event before being removed.",
            "!url": "http://gruntjs.com/api/grunt.event#grunt.event.many"
          },
          off: {
            "!type": "fn(event: Event, listener: ?)",
            "!doc": "Remove a listener from the listener array for the specified event.",
            "!url": "http://gruntjs.com/api/grunt.event#grunt.event.off"
          },
          removeAllListeners: {
            "!type": "fn(event: [Event])",
            "!doc": "Removes all listeners, or those of the specified event.",
            "!url": "http://gruntjs.com/api/grunt.event#grunt.event.removealllisteners"
          },
          emit: {
            "!type": "fn(event: Event, arg: [?])",
            "!doc": "Execute each of the listeners that may be listening for the specified event name in order with the list of arguments.",
            "!url": "http://gruntjs.com/api/grunt.event#grunt.event.emit"
          }
        },
        fail: {
          "!doc": "For when something goes horribly wrong.",
          "!url": "http://gruntjs.com/api/grunt.fail",
          warn: {
            "!type": "fn(error: Error, errorcode?: number)",
            "!doc": "Display a warning and abort Grunt immediately.",
            "!url": "http://gruntjs.com/api/grunt.fail#grunt.warn"
          },
          fatal: {
            "!type": "fn(error: Error, errorcode?: number)",
            "!doc": "Display a warning and abort Grunt immediately.",
            "!url": "http://gruntjs.com/api/grunt.fail#grunt.fatal"
          }
        },
        fatal: {
          "!type": "Grunt.fail.fatal"
        },
        file: {
          "!doc": "Reading and writing files, traversing the filesystem and finding files by matching globbing patterns.",
          "!url": "http://gruntjs.com/api/grunt.file",
          defaultEncoding: {
            "!type": "string",
            "!doc": "Set this property to change the default encoding used by all grunt.file methods. Defaults to 'utf8'.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.defaultencoding"
          },
          preserveBOM: {
            "!type": "bool",
            "!doc": "Whether to preserve the Byte Order Mark (BOM) on file.read rather than strip it.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.preservebom"
          },
          read: {
            "!type": "fn(filePath: string, options?: ?) -> string|Buffer",
            "!doc": "Read and return a file's contents. Returns a string, unless options.encoding is null in which case it returns a Buffer.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.read"
          },
          readJSON: {
            "!type": "fn(filePath: string, options?: ?) -> string|Buffer",
            "!doc": "Read a file's contents, parsing the data as JSON and returning the result.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.readjson"
          },
          readYAML: {
            "!type": "fn(filePath: string, options?: ?) -> string|Buffer",
            "!doc": "Read a file's contents, parsing the data as YAML and returning the result.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.readyaml"
          },
          write: {
            "!type": "fn(filepath: string, contents: string, options?: ?)",
            "!doc": "Write the specified contents to a file, creating intermediate directories if necessary.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.write"
          },
          copy: {
            "!type": "fn(srcpath: string, destpath: string, options?: ?)",
            "!doc": "Copy a source file to a destination path, creating intermediate directories if necessary.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.copy"
          },
          delete: {
            "!type": "fn(filepath: string, options?: ?)",
            "!doc": "Delete the specified filepath. Will delete files and folders recursively.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.delete"
          },
          mkdir: {
            "!type": "fn(dirpath: string, mode?: string)",
            "!doc": "Works like mkdir -p. Create a directory along with any intermediate directories. If mode isn't specified, it defaults to 0777 & (~process.umask()).",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.mkdir"
          },
          recurse: {
            "!type": "fn(rootdir: string, callback: fn())",
            "!doc": "Recurse into a directory, executing callback for each file.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.recurse"
          },
          expand: {
            "!type": "fn(options?: ?, patterns: string) -> [string]",
            "!doc": "Return a unique array of all file or directory paths that match the given globbing pattern(s).",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.expand"
          },
          expandMapping: {
            "!type": "fn(patterns: string, dest: string, options?: ?) -> [string]",
            "!doc": "Returns an array of src-dest file mapping objects. For each source file matched by a specified pattern, join that file path to the specified dest.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.expandmapping"
          },
          match: {
            "!type": "fn(options?: ?, patterns: string|[string], filepaths:string|[string]) -> [string]",
            "!doc": "Match one or more globbing patterns against one or more file paths. Returns a uniqued array of all file paths that match any of the specified globbing patterns.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.match"
          },
          isMatch: {
            "!type": "fn(options?: ?, patterns: string|[string], filepaths: string|[string]) -> bool",
            "!doc": "This method contains the same signature and logic as the grunt.file.match method, but simply returns true if any files were matched, otherwise false.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.ismatch"
          },
          exists: {
            "!type": "fn(path1: string, path2?: string) -> bool",
            "!doc": "Does the given path exist? Returns a boolean.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.exists"
          },
          isLink: {
            "!type": "fn(path1: string, path2?: string) -> bool",
            "!doc": "Is the given path a symbolic link? Returns a boolean.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.islink"
          },
          isDir: {
            "!type": "fn(path1: string, path2?: string) -> bool",
            "!doc": "Is the given path a directory? Returns a boolean.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.isdir"
          },
          isFile: {
            "!type": "fn(path1: string, path2?: string) -> bool",
            "!doc": "Is the given path a file? Returns a boolean.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.isfile"
          },
          isPathAbsolute: {
            "!type": "fn(path1: string, path2?: string) -> bool",
            "!doc": "Is a given file path absolute? Returns a boolean.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.ispathabsolute"
          },
          arePathsEquivalent: {
            "!type": "fn(path1: string, path2?: string) -> bool",
            "!doc": "Do all the specified paths refer to the same path? Returns a boolean.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.arepathsequivalent"
          },
          doesPathContain: {
            "!type": "fn(ancestorPath: string, descendantPath1: string, descendantPath2?: string) -> bool",
            "!doc": "Are all descendant path(s) contained within the specified ancestor path? Returns a boolean.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.doespathcontain"
          },
          isPathCwd: {
            "!type": "fn(path1: string, path2?: string) -> bool",
            "!doc": "Is a given file path the CWD? Returns a boolean.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.ispathcwd"
          },
          isPathInCwd: {
            "!type": "fn(path1: string, path2?: string) -> bool",
            "!doc": "Is a given file path inside the CWD? Note: CWD is not inside CWD. Returns a boolean.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.ispathincwd"
          },
          setBase: {
            "!type": "fn(path: string)",
            "!doc": "Change grunt's current working directory (CWD). By default, all file paths are relative to the Gruntfile.",
            "!url": "http://gruntjs.com/api/grunt.file#grunt.file.setbase"
          }
        },
        initConfig: {
          "!type": "Grunt.config.init"
        },
        loadNpmTasks: {
          "!type": "Grunt.task.loadNpmTasks"
        },
        loadTasks: {
          "!type": "Grunt.task.loadTasks"
        },
        log: {
          "!doc": "Output messages to the console.",
          "!url": "http://gruntjs.com/api/grunt.log",
          write: {
            "!type": "fn(msg: string)",
            "!doc": "Log the specified msg string, with no trailing newline.",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.write-grunt.verbose.write"
          },
          writeln: {
            "!type": "fn(msg?: string)",
            "!doc": "Log the specified msg string, with trailing newline.",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.writeln-grunt.verbose.writeln"
          },
          error: {
            "!type": "fn(msg?: string)",
            "!doc": "If msg string is omitted, logs ERROR in red, otherwise logs >> msg, with trailing newline.",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.error-grunt.verbose.error"
          },
          errorlns: {
            "!type": "fn(msg: string)",
            "!doc": "Log an error with grunt.log.error, wrapping text to 80 columns using grunt.log.wraptext",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.errorlns-grunt.verbose.errorlns"
          },
          ok: {
            "!type": "fn(msg?: string)",
            "!doc": "If msg string is omitted, logs OK in green, otherwise logs >> msg, with trailing newline.",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.ok-grunt.verbose.ok"
          },
          oklns: {
            "!type": "fn(msg: string)",
            "!doc": "Log an ok message with grunt.log.ok, wrapping text to 80 columns using grunt.log.wraptext",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.oklns-grunt.verbose.oklns"
          },
          subhead: {
            "!type": "fn(msg: string)",
            "!doc": "Log the specified msg string in bold, with trailing newline.",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.subhead-grunt.verbose.subhead"
          },
          writeflags: {
            "!type": "fn(obj: ?, prefix: string)",
            "!doc": "Log a list of obj properties (good for debugging flags).",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.writeflags-grunt.verbose.writeflags"
          },
          debug: {
            "!type": "fn(msg: string)",
            "!doc": "Logs a debugging message, but only if the --debug command-line option was specified.",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.debug-grunt.verbose.debug"
          },
          wordlist: {
            "!type": "fn(arr: [string], options?: ?) -> string",
            "!doc": "Returns a comma-separated list of arr array items.",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.wordlist"
          },
          uncolor: {
            "!type": "fn(str: string) -> string",
            "!doc": "Removes all color information from a string, making it suitable for testing .length or perhaps logging to a file.",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.uncolor"
          },
          wraptext: {
            "!type": "fn(width: number, text: string) -> string",
            "!doc": "Wrap text string to width characters with \n, ensuring that words are not split in the middle unless absolutely necessary.",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.wraptext"
          },
          table: {
            "!type": "fn(widths: number, texts: [string]) -> string",
            "!doc": "Wrap texts array of strings to columns widths characters wide. A wrapper for the grunt.log.wraptext method that can be used to generate output in columns.",
            "!url": "http://gruntjs.com/api/grunt.log#grunt.log.table"
          }
        },
        option: {
          "!type": "fn(key: ?, val?: ?) -> ?",
          "!doc": "Gets or sets an option.",
          "!url": "http://gruntjs.com/api/grunt.option#grunt.option",
          init: {
            "!type": "fn(initObject?: ?)",
            "!doc": "Initialize grunt.option. If initObject is omitted option will be initialized to an empty object otherwise will be set to initObject.",
            "!url": "http://gruntjs.com/api/grunt.option#grunt.option.init"
          },
          flags: {
            "!type": "fn() -> [string]",
            "!doc": "Returns the options as an array of command line parameters.",
            "!url": "http://gruntjs.com/api/grunt.option#grunt.option.flags"
          }
        },
        package: {
          "!type": "?",
          "!doc": "The current Grunt package.json metadata, as an object.",
          "!url": "http://gruntjs.com/api/grunt#grunt.package"
        },
        registerMultiTask: {
          "!type": "Grunt.task.registerMultiTask"
        },
        registerTask: {
          "!type": "Grunt.task.registerTask"
        },
        renameTask: {
          "!type": "Grunt.task.renameTask"
        },
        task: {
          "!doc": "Register, run and load external tasks.",
          "!url": "http://gruntjs.com/api/grunt.task",
          registerTask: {
            "!type": "fn(taskName: string, taskList: [string])",
            "!doc": "Register an 'alias task' or a task function. This method supports the following two signatures:",
            "!url": "http://gruntjs.com/api/grunt.task#grunt.task.registertask",
            "!effects": ["custom grunt_registerTask"]
          },
          registerMultiTask: {
            "!type": "fn(taskName: string, description: string, taskFunction: fn())",
            "!doc": "Register an 'alias task' or a task function. This method supports the following two signatures:",
            "!url": "http://gruntjs.com/api/grunt.task#grunt.task.registermultitask",
            "!effects": ["custom grunt_registerTask"]
          },
          requires: {
            "!type": "fn(taskName: string)",
            "!doc": "Fail the task if some other task failed or never ran.",
            "!url": "http://gruntjs.com/api/grunt.task#grunt.task.requires"
          },
          exists: {
            "!type": "fn(taskName: string) -> bool",
            "!doc": "Check with the name, if a task exists in the registered tasks. Return a boolean.",
            "!url": "http://gruntjs.com/api/grunt.task#grunt.task.exists"
          },
          renameTask: {
            "!type": "fn(oldname: string, newname: string) -> bool",
            "!doc": "Rename a task. This might be useful if you want to override the default behavior of a task, while retaining the old name.",
            "!url": "http://gruntjs.com/api/grunt.task#grunt.task.renametask"
          },
          loadTasks: {
            "!type": "fn(tasksPath: string)",
            "!doc": "Load task-related files from the specified directory, relative to the Gruntfile. This method can be used to load task-related files from a local Grunt plugin by specifying the path to that plugin's 'tasks' subdirectory.",
            "!url": "http://gruntjs.com/api/grunt.task#grunt.task.loadtasks"
          },
          loadNpmTasks: {
            "!type": "fn(pluginName: string)",
            "!doc": "Load tasks from the specified Grunt plugin. This plugin must be installed locally via npm, and must be relative to the Gruntfile. Grunt plugins can be created by using the grunt-init gruntplugin template: grunt init:gruntplugin.",
            "!url": "http://gruntjs.com/api/grunt.task#grunt.task.loadnpmtasks"
          },
          run: {
            "!type": "fn(taskList: string|[string])",
            "!doc": "Enqueue one or more tasks. Every specified task in taskList will be run immediately after the current task completes, in the order specified. The task list can be an array of tasks or individual task arguments.",
            "!url": "http://gruntjs.com/api/grunt.task#grunt.task.run"
          },
          clearQueue: {
            "!type": "fn()",
            "!doc": "Empty the task queue completely. Unless additional tasks are enqueued, no more tasks will be run.",
            "!url": "http://gruntjs.com/api/grunt.task#grunt.task.clearqueue"
          },
          normalizeMultiTaskFiles: {
            "!type": "fn(data: ?, targetname?: string)",
            "!doc": "Normalizes a task target configuration object into an array of src-dest file mappings. This method is used internally by the multi task system this.files / grunt.task.current.files property.",
            "!url": "http://gruntjs.com/api/grunt.task#grunt.task.normalizemultitaskfiles"
          }
        },
        template: {
          "!doc": "Template strings can be processed manually using the provided template functions.",
          "!url": "http://gruntjs.com/api/grunt.template",
          process: {
            "!type": "fn(template: string, options?: ?) -> string",
            "!doc": "Process a Lo-Dash template string. The template argument will be processed recursively until there are no more templates to process.",
            "!url": "http://gruntjs.com/api/grunt.template#grunt.template.process"
          },
          setDelimiters: {
            "!type": "fn(name: string)",
            "!doc": "Set the Lo-Dash template delimiters to a predefined set in case grunt.util._.template needs to be called manually. The config delimiters <% %> are included by default.",
            "!url": "http://gruntjs.com/api/grunt.template#grunt.template.setdelimiters"
          },
          addDelimiters: {
            "!type": "fn(name: string, opener: string, closer: string)",
            "!doc": "Add a named set of Lo-Dash template delimiters.",
            "!url": "http://gruntjs.com/api/grunt.template#grunt.template.adddelimiters"
          },
          date: {
            "!type": "fn(date: number, format: string) -> string",
            "!doc": "Format a date using the dateformat library(https://github.com/felixge/node-dateformat).",
            "!url": "http://gruntjs.com/api/grunt.template#grunt.template.date"
          },
          today: {
            "!type": "fn(format: string) -> string",
            "!doc": "Format today's date using the dateformat library(https://github.com/felixge/node-dateformat).",
            "!url": "http://gruntjs.com/api/grunt.template#grunt.template.today"
          }
        },
        util: {
          "!doc": "Miscellaneous utilities for your Gruntfile and tasks.",
          "!url": "http://gruntjs.com/api/grunt.util",
          kindOf: {
            "!type": "fn(value: ?) -> ?",
            "!doc": "Return the 'kind' of a value. Like typeof but returns the internal [Class](Class/) value.",
            "!url": "http://gruntjs.com/api/grunt.util#grunt.util.kindof"
          },
          error: {
            "!type": "fn(message: string, origError?: ?) -> ?",
            "!doc": "Return a new Error instance (that can be thrown) with the appropriate message.",
            "!url": "http://gruntjs.com/api/grunt.util#grunt.util.error"
          },
          linefeed: {
            "!type": "string",
            "!doc": "The linefeed character, normalized for the current operating system. (\r\n on Windows, \n otherwise)",
            "!url": "http://gruntjs.com/api/grunt.util#grunt.util.linefeed"
          },
          normalizelf: {
            "!type": "fn(str: string) -> string",
            "!doc": "Given a string, return a new string with all the linefeeds normalized for the current operating system. (\r\n on Windows, \n otherwise)",
            "!url": "http://gruntjs.com/api/grunt.util#grunt.util.normalizelf"
          },
          recurse: {
            "!type": "fn(object: ?, callbackFunction: fn(), continueFunction: fn())",
            "!doc": "Recurse through nested objects and arrays, executing callbackFunction for each non-object value.",
            "!url": "http://gruntjs.com/api/grunt.util#grunt.util.recurse"
          },
          repeat: {
            "!type": "fn(n: number, str: string) -> string",
            "!doc": "Return string str repeated n times.",
            "!url": "http://gruntjs.com/api/grunt.util#grunt.util.repeat"
          },
          pluralize: {
            "!type": "fn(n: number, str: string, separator: string) -> ?",
            "!doc": "Given str of 'a/b', If n is 1, return 'a' otherwise 'b'. You can specify a custom separator if '/' doesn't work for you.",
            "!url": "http://gruntjs.com/api/grunt.util#grunt.util.pluralize"
          },
          spawn: {
            "!type": "fn(options: ?, doneFunction: fn()) -> ?",
            "!doc": "Spawn a child process, keeping track of its stdout, stderr and exit code. The method returns a reference to the spawned child.",
            "!url": "http://gruntjs.com/api/grunt.util#grunt.util.spawn"
          },
          toArray: {
            "!type": "fn(arrayLikeObject: ?) -> [?]",
            "!doc": "Given an array or array-like object, return an array. Great for converting arguments objects into arrays.",
            "!url": "http://gruntjs.com/api/grunt.util#grunt.util.toarray"
          },
          callbackify: {
            "!type": "fn(syncOrAsyncFunction: fn()) -> fn()",
            "!doc": "Normalizes both 'returns a value' and 'passes result to a callback' functions to always pass a result to the specified callback.",
            "!url": "http://gruntjs.com/api/grunt.util#grunt.util.callbackify"
          }
        },
        verbose: {
          "!type": "Grunt.log"
        },
        version: {
          "!type": "string",
          "!doc": "The current Grunt version, as a string. This is just a shortcut to the grunt.package.version property.",
          "!url": "http://gruntjs.com/api/grunt#grunt.version"
        },
        warn: {
          "!type": "Grunt.fail.warn"
        }
      }
    }
  };

});
