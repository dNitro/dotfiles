(function(mod) {
  if (typeof exports == "object" && typeof module == "object") { // CommonJS
    return mod(require("tern/lib/infer"), require("tern/lib/tern"));
  }
  if (typeof define == "function" && define.amd) // AMD
    return define([ "tern/lib/infer", "tern/lib/tern" ], mod);
  mod(tern, tern);
})(function(infer, tern) {
  "use strict";

  tern.registerPlugin("mocha", function(server, options) {
    var style = options.style || "bdd";
    return {
      defs : defs[style.toLowerCase()],
    };
  });

  var defs = {
    "bdd": {
      "!name": "mocha",
      "!define": {
        "!suite": {
          "retries": {
            "!type": "fn(n: number)",
            "!doc": "You can choose to retry failed tests up to a certain number of times."
          },
          "slow": {
            "!type": "fn(n: number)",
            "!doc": "To tweak what’s considered “slow”, you can use the slow() method"
          },
          "timeout": {
            "!type": "fn(n: number)",
            "!doc": "Suite-level/Test-specific timeouts may be applied, or the use of this.timeout(0) to disable timeouts all together"
          },
        }
      },
      "after": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "afterEach": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "before": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "beforeEach": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "context": {
        "!type": "fn(description: string, f: fn(done?: fn(err: +Error)))",
        "!effects": ["call !1 this=!suite"],
        "!doc": "context() is just an alias for describe(), and behaves the same way; it just provides a way to keep tests easier to read and organized."
      },
      "describe": {
        "!type": "fn(description: string, f: fn(done?: fn(err: +Error)))",
        "!effects": ["call !1 this=!suite"],
        "!doc": ""
      },
      "it": {
        "!type": "fn(description: string, f: fn(done?: fn(err: +Error)))",
        "!effects": ["call !1 this=!suite"],
        "!doc": ""
      },
      "specify": {
        "!type": "fn(description: string, f: fn(done?: fn(err: +Error)))",
        "!effects": ["call !1 this=!suite"],
        "!doc": "specify() is just an alias for it()., and behaves the same way; it just provides a way to keep tests easier to read and organized."
      }
    },
    "tdd": {
      "!name": "mocha",
      "!define": {
        "!suite": {
          "retries": {
            "!type": "fn(n: number)",
            "!doc": "You can choose to retry failed tests up to a certain number of times."
          },
          "slow": {
            "!type": "fn(n: number)",
            "!doc": "To tweak what’s considered “slow”, you can use the slow() method"
          },
          "timeout": {
            "!type": "fn(n: number)",
            "!doc": "Suite-level/Test-specific timeouts may be applied, or the use of this.timeout(0) to disable timeouts all together"
          },
        }
      },
      "setup": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "suite": {
        "!type": "fn(description: string, f: fn(done?: fn(err: +Error)))",
        "!effects": ["call !1 this=!suite"],
        "!doc": ""
      },
      "suiteSetup": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "suiteTeardown": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "teardown": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "test": {
        "!type": "fn(description: string, f: fn(done?: fn(err: +Error)))",
        "!effects": ["call !1 this=!suite"],
        "!doc": ""
      }
    },
    "qunit": {
      "!name": "mocha",
      "!define": {
        "!suite": {
          "retries": {
            "!type": "fn(n: number)",
            "!doc": "You can choose to retry failed tests up to a certain number of times."
          },
          "slow": {
            "!type": "fn(n: number)",
            "!doc": "To tweak what’s considered “slow”, you can use the slow() method"
          },
          "timeout": {
            "!type": "fn(n: number)",
            "!doc": "Suite-level/Test-specific timeouts may be applied, or the use of this.timeout(0) to disable timeouts all together"
          },
        }
      },
      "after": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "afterEach": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "before": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "beforeEach": {
        "!type": "fn(f: fn(done: fn(err: +Error)))",
        "!doc": ""
      },
      "suite": {
        "!type": "fn(description: string)",
        "!doc": ""
      },
      "test": {
        "!type": "fn(description: string, f: fn(done?: fn(err: +Error)))",
        "!effects": ["call !1 this=!suite"],
        "!doc": ""
      }
    }
  };

});

