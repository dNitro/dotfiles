(function(mod) {
  if (typeof exports == "object" && typeof module == "object") // CommonJS
    return mod(require("tern/lib/infer"), require("tern/lib/tern"));
  if (typeof define == "function" && define.amd) // AMD
    return define([ "tern/lib/infer", "tern/lib/tern" ], mod);
  mod(tern, tern);
})(function(infer, tern) {
  "use strict";

  tern.registerPlugin("qunit", function(server, options) {

    return {
      defs : defs
    };
  });

  var defs = {
  "!name": "qunit",
  "!define": {
    "Assert": {
      "!doc": "Namespace for QUnit assertions",
      "async": {
        "!type": "fn(acceptCallCount?: number) -> fn()",
        "!doc": "Instruct QUnit to wait for an asynchronous operation.",
        "!url": "http://api.qunitjs.com/async/"
      },
      "deepEqual": {
        "!type": "fn(actual: ?, expected: ?, message?: string)",
        "!doc": "A deep recursive comparison, working on primitive types, arrays, objects, regular expressions, dates and functions.",
        "!url": "http://api.qunitjs.com/deepEqual/"
      },
      "equal": {
        "!type": "fn(actual: ?, expected: ?, message?: string)",
        "!doc": "A non-strict comparison, roughly equivalent to JUnit’s assertEquals.",
        "!url": "http://api.qunitjs.com/equal/"
      },
      "expect": {
        "!type": "fn(amount: number)",
        "!doc": "Specify how many assertions are expected to run within a test.",
        "!url": "http://api.qunitjs.com/expect/"
      },
      "notDeepEqual": {
        "!type": "fn(actual: ?, expected: ?, message?: string)",
        "!doc": "An inverted deep recursive comparison, working on primitive types, arrays, objects, regular expressions, dates and functions.",
        "!url": "http://api.qunitjs.com/notDeepEqual/"
      },
      "notEqual": {
        "!type": "fn(actual: ?, expected: ?, message: string)",
        "!doc": "A non-strict comparison, checking for inequality.",
        "!url": "http://api.qunitjs.com/notEqual/"
      },
      "notOk": {
        "!type": "fn(state: +Expression, message?: string)",
        "!doc": "A boolean check, inverse of ok() and CommonJS’s assert.ok(), and equivalent to JUnit’s assertFalse(). Passes if the first argument is falsy.",
        "!url": "http://api.qunitjs.com/notOk/"
      },
      "notPropEqual": {
        "!type": "fn(actual: ?, expected: ?, message?: string)",
        "!doc": "A strict comparison of an object’s own properties, checking for inequality.",
        "!url": "http://api.qunitjs.com/notPropEqual/"
      },
      "notStrictEqual": {
        "!type": "fn(actual: ?, expected: ?, message?: string)",
        "!doc": "A strict comparison, checking for inequality.",
        "!url": "http://api.qunitjs.com/notStrictEqual/"
      },
      "ok": {
        "!type": "fn(state: +Expression, message?: string)",
        "!doc": "A boolean check, equivalent to CommonJS’s assert.ok() and JUnit’s assertTrue(). Passes if the first argument is truthy.",
        "!url": "http://api.qunitjs.com/ok/"
      },
      "propEqual": {
        "!type": "fn(actual: ?, expected: ?, message: string)",
        "!doc": "A strict type and value comparison of an object’s own properties.",
        "!url": "http://api.qunitjs.com/propEqual/"
      },
      "pushResult": {
        "!type": "fn(assertionResult: ?)",
        "!doc": "Report the result of a custom assertion",
        "!url": "http://api.qunitjs.com/pushResult/"
      },
      "strictEqual": {
        "!type": "fn(actual: ?, expected: ?, message?: string)",
        "!doc": "A strict type and value comparison.",
        "!url": "http://api.qunitjs.com/pushResult/"
      },
      "throws": {
        "!type": "fn(block: fn(), expected?: ?, message?: string)",
        "!doc": "Test if a callback throws an exception, and optionally compare the thrown error.",
        "!url": "http://api.qunitjs.com/throws/"
      }
    }
  },
  "QUnit": {
    "begin": {
      "!type": "fn(callback: fn(details: ?))",
      "!doc": "Register a callback to fire whenever the test suite begins.",
      "!url": "http://api.qunitjs.com/QUnit.begin/"
    },
    "config": {
      "!doc": "Configuration for QUnit",
      "!url": "http://api.qunitjs.com/QUnit.config/",
      "altertitle": {
        "!type": "bool",
        "!doc": "By default, QUnit updates document.title to add a checkmark or x-mark to indicate if a testsuite passed or failed. This makes it easy to see a suites result even without looking at a tab's content.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "autostart": {
        "!type": "bool",
        "!doc": "By default, QUnit runs tests when load event is triggered on the window. If you're loading tests asynchronously, you can set this property to false, then call QUnit.start() once everything is loaded.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "collapse": {
        "!type": "bool",
        "!doc": "Setting this value to false will expand the details for every failing test.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "current": {
        "!doc": "This Object gives you access to some QUnit internals at runtime.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "hidepassed": {
        "!type": "bool",
        "!doc": "By default, the HTML Reporter will show all the tests results. Enabling this option will make it show only the failing tests, hiding all that pass.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "module": {
        "!type": "string",
        "!doc": "Specify a single module to run by name (exact case-insensitive match required). By default, QUnit will run all the loaded modules when this property is not specified.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "moduled": {
        "!type": "[string]",
        "!doc": "This property allows QUnit to run specific modules identified by the hashed version of their module name. You can specify one or multiple modules to run.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "seed": {
        "!type": "string",
        "!doc": "This property tells QUnit to run tests in a seeded-random order.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "reorder": {
        "!type": "bool",
        "!doc": "By default, QUnit will run tests first that failed on a previous run. In a large testsuite, this can speed up testing a lot.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "requireExpects": {
        "!type": "bool",
        "!doc": "The expect() method is optional by default, though it can be useful to require each test to specify the number of expected assertions.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "testId": {
        "!type": "[?]",
        "!doc": "This property allows QUnit to run specific tests identified by the hashed version of their module name and test name. You can specify one or multiple tests to run.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "testTimeout": {
        "!type": "number",
        "!doc": "Specify a global timeout in milliseconds after which all tests will fail with an appropriate message.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "scrolltop": {
        "!type": "bool",
        "!doc": "By default, scroll to top of the page when suite is done. Setting this to false will leave the page scroll alone.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
      "urlConfig": {
        "!type": "bool",
        "!doc": "This property controls which form controls to put into the QUnit toolbar element (below the header). By default, the 'noglobals' and 'notrycatch' checkboxes are there.",
        "!url": "http://api.qunitjs.com/QUnit.config/"
      },
    },
    "done": {
      "!type": "fn(callback: fn(details: ?))",
      "!doc": "Register a callback to fire whenever the test suite ends.",
      "!url": "http://api.qunitjs.com/QUnit.done/"
    },
    "dump": {
      "parse": {
        "!type": "fn(data: ?)",
        "!doc": "Advanced and extensible data dumping for JavaScript",
        "!url": "http://api.qunitjs.com/QUnit.dump.parse/"
      },
      "maxDepth": {
        "!type": "number",
        "!doc": "Representing how deep the elements should be parsed.",
        "!url": "http://api.qunitjs.com/QUnit.dump.parse/"
      }
    },
    "extend": {
      "!type": "fn(target: ?, mixin: ?)",
      "!doc": "Copy the properties defined by the mixin object into the target object",
      "!url": "http://api.qunitjs.com/QUnit.extend/"
    },
    "log": {
      "!type": "fn(callback: fn(details: ?))",
      "!doc": "Register a callback to fire whenever an assertion completes.",
      "!url": "http://api.qunitjs.com/QUnit.log/"
    },
    "module": {
      "!type": "fn(name: string, hooks?: +PlainObject, nested?: fn(hooks: ?))",
      "!effects": ["call !2 !1"],
      "!doc": "Group related tests under a single label.",
      "!url": "http://api.qunitjs.com/QUnit.module/"
    },
    "moduleDone": {
      "!type": "fn(callback: fn(details: ?))",
      "!doc": "Register a callback to fire whenever a module ends.",
      "!url": "http://api.qunitjs.com/QUnit.moduleDone/"
    },
    "moduleStart": {
      "!type": "fn(callback: fn(details: ?))",
      "!doc": "Register a callback to fire whenever a module begins.",
      "!url": "http://api.qunitjs.com/QUnit.moduleStart/"
    },
    "only": {
      "!type": "fn(name: string, callback: fn(assert: +Assert))",
      "!doc": "Adds a test to exclusively run, preventing all other tests from running.",
      "!url": "http://api.qunitjs.com/QUnit.only/"
    },
    "push": {
      "!type": "fn(result: bool, actual: ?, expected: ?, message?: string)",
      "!doc": "DEPRECATED: Report the result of a custom assertion",
      "!url": "http://api.qunitjs.com/QUnit.push/"
    },
    "skip": {
      "!type": "fn(name: string, callback: fn(assert: +Assert))",
      "!doc": "Adds a test like object to be skipped",
      "!url": "http://api.qunitjs.com/QUnit.skip/"
    },
    "stack": {
      "!type": "fn(offset: number)",
      "!doc": "Returns a single line string representing the stacktrace (call stack)",
      "!url": "http://api.qunitjs.com/QUnit.stack/"
    },
    "start": {
      "!type": "fn()",
      "!doc": "QUnit.start() must be used to start a test run that has QUnit.config.autostart set to false.\nThis method was previously used to control async tests on text contexts along with QUnit.stop. For asynchronous tests, use assert.async instead.",
      "!url": "http://api.qunitjs.com/QUnit.start/"
    },
    "test": {
      "!type": "fn(name: string, callback: fn(assert: +Assert))",
      "!doc": "Add a test to run.",
      "!utl": "http://api.qunitjs.com/QUnit.test/"
    },
    "testDone": {
      "!type": "fn(callback: fn(details: ?))",
      "!doc": "Register a callback to fire whenever a test ends.",
      "!url": "http://api.qunitjs.com/QUnit.testDone/"
    },
    "testStart": {
      "!type": "fn(callback: fn(details: ?))",
      "!doc": "Register a callback to fire whenever a test begins.",
      "!url": "http://api.qunitjs.com/QUnit.testStart/"
    }
  }
};
});
