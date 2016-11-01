(function(mod) {
  if (typeof exports == "object" && typeof module == "object") { // CommonJS
    return mod(require("tern/lib/infer"), require("tern/lib/tern"));
  }
  if (typeof define == "function" && define.amd) // AMD
    return define([ "tern/lib/infer", "tern/lib/tern" ], mod);
  mod(tern, tern);
})(function(infer, tern) {
  "use strict";

  /**
   * For Jasmine API doc. See https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/ch04.html
   */

  infer.registerFunction("jasmineExpect", function(_self, args, argNodes) {
    var cx = infer.cx();
    return cx.definitions["jasmine"]["!jasmine"];
  });

  infer.registerFunction("spyChaining", function(_self, args, argNodes) {
    var cx = infer.cx();
    return cx.definitions["jasmine"]["!spies"];
  });

  infer.registerFunction("jasmineClock", function(_self, args, argNodes) {
    var cx = infer.cx();
    return cx.definitions["jasmine"]["!jasmineClock"];
  });

  infer.registerFunction("call", function(_self, args, argNodes) {
    var cx = infer.cx();
    return cx.definitions["jasmine"]["!call"];
  });

  tern.registerPlugin("jasmine", function(server, options) {
    return {
      defs : defs,
      passes: {
          postLoadDef: postLoadDef
      }
    };
  });

  function postLoadDef(data) {
    if (data["!name"] === 'jasmine') return;
    var cx = infer.cx(), interfaces = cx.definitions[data["!name"]]["!jasmine"];
    if (interfaces) {
      // it's a custom matchers, fill !jasmine object with custom property matchers.
      var to = cx.definitions["jasmine"]["!jasmine"];
      var from = interfaces;
      from.forAllProps(function(prop, val, local) {
        if (local && prop != "<i>") to.propagate(new infer.PropHasSubset(prop, val));
      });
    }
  }

  var defs = {
    "!name": "jasmine",
    "!define": {
      "!self": {},
      "!call": {
        "object": "?",
        "args": "[?]",
        "returnValue": "?"
      },
      "!jasmine": {
        "not": {
          "!type": "!jasmine",
           "!doc": "It’s frequently useful to reverse Jasmine's matchers to make sure that they aren't true. To do that, simply prefix things with .not",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_negate_other_matchers_with_not.html"
        },
        "toBeDefined": {
          "!type": "fn(expected: ?)",
          "!doc": "As with truthiness and falsiness, there are matchers to check if something is defined or undefined.",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_is_it_defined_tobedefined_tobeundefined.html"
        },
        "toBe": {
          "!type": "fn(expected: ?)",
          "!doc": "At first, the toBe matcher looks a lot like the toEqual matcher, but it's not exactly the same. toBe checks if two things are the same object, not just if they are equivalent.",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_identity_tobe.html"
        },
        "toBeCloseTo": {
          "!type": "fn(expected: number, precision: number)",
          "!doc": "toBeCloseTo allows you to check if a number is close to another number, given a certain amount of decimal precision as the second argument."
        },
        "toBeFalsy": {
          "!type": "fn()",
          "!doc": "To test if something evaluates to false, you use the toBeFalsy matcher.",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_yes_or_no_tobetruthy_tobefalsy.html"
        },
        "toBeTruthy": {
          "!type": "fn()",
          "!doc": "To test if something evaluates to true, you use the toBeTruthy matcher.",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_yes_or_no_tobetruthy_tobefalsy.html"
        },
        "toBeGreaterThan": {
          "!type": "fn(expected: ?)",
          "!doc": "The toBeGreaterThan and toBeLessThan matchers check if something is greater than or less than something else.",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_comparators_tobegreaterthan_tobelessthan.html"
        },
        "toBeLessThan": {
          "!type": "fn(expected: ?)",
          "!doc": "The toBeGreaterThan and toBeLessThan matchers check if something is greater than or less than something else.",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_comparators_tobegreaterthan_tobelessthan.html"
        },
        "toBeNaN": {
          "!type": "fn()",
          "!doc": "Like toBeNull, toBeNaN checks if something is NaN",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_is_it_nan_tobenan.html"
        },
        "toBeNull": {
          "!type": "fn()",
          "!doc": "The toBeNull matcher is fairly straightforward. If you hadn’t guessed by now, it checks if something is null",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_nullness_tobenull.html"
        },
        "toBeUndefined": {
          "!type": "fn(expected: ?)",
          "!doc": "As with truthiness and falsiness, there are matchers to check if something is defined or undefined.",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_is_it_defined_tobedefined_tobeundefined.html"
        },
        "toContain": {
          "!type": "fn(expected: ?)",
          "!doc": "Sometimes you want to verify that an element is a member of an array, somewhere. To do that, you can use the toContain matcher:",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_check_if_an_element_is_present_with_tocontain.html"
        },
        "toEqual": {
          "!type": "fn(expected: ?)",
          "!doc": "Perhaps the simplest matcher in Jasmine is toEqual. It simply checks if two things are equal (and not necessarily the same exact object).",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_equality_toequal.html"
        },
        "toHaveBeenCalled": {
          "!type": "fn(expected: ?)",
          "!doc": "The toHaveBeenCalled matcher will return true if the spy was called."
        },
        "toHaveBeenCalledTimes": {
          "!type": "fn(expected: ?)",
          "!doc": "The toHaveBeenCalledTimes matcher will pass if the spy was called the specified number of times."
        },
        "toHaveBeenCalledWith": {
          "!type": "fn(expected: ?)",
          "!doc": "The toHaveBeenCalledWith matcher will return true if the argument list matches any of the recorded calls to the spy."
        },
        "toMatch": {
          "!type": "fn(expected: +RegExp)",
          "!doc": "toMatch checks if something is matched, given a regular expression. It can be passed as a regular expression or a string, which is then parsed as a regular expression.",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_using_tomatch_with_regular_expressions.html"
        },
        "toThrow": {
          "!type": "fn()",
          "!doc": "toThrow lets you express, 'Hey, I expect this function to throw an error'",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_checking_if_a_function_throws_an_error_with_tothrow.html"
        },
        "toThrowError": {
          "!type": "fn()",
          "!doc": "toThrow lets you express, 'Hey, I expect this function to throw an error'",
          "!url": "https://www.safaribooksonline.com/library/view/javascript-testing-with/9781449356729/_checking_if_a_function_throws_an_error_with_tothrow.html"
        }
      },
      "!spies": {
        "and": {
          "callThrough": {
            "!type": "fn()",
            "!doc": "By chaining the spy with and.callThrough, the spy will still track all calls to it but in addition it will delegate to the actual implementation."
          },
          "returnValue": {
            "!type": "fn(value: ?)",
            "!doc": "By chaining the spy with and.returnValue, all calls to the function will return a specific value."
          },
          "returnValues": {
            "!type": "fn(value1: ?, value2: ?)",
            "!doc": "By chaining the spy with and.returnValues, all calls to the function will return specific values in order until it reaches the end of the return values list, at which point it will return undefined for all subsequent calls."
          },
          "callFake": {
            "!type": "fn(func: fn())",
            "!doc": "By chaining the spy with and.callFake, all calls to the spy will delegate to the supplied function."
          },
          "throwError": {
            "!type": "fn(value: ?)",
            "!doc": "By chaining the spy with and.throwError, all calls to the spy will throw the specified value as an error."
          },
          "stub": {
            "!type": "fn()",
            "!doc": "When a calling strategy is used for a spy, the original stubbing behavior can be returned at any time with and.stub."
          },
          "identity": {
            "!type": "fn()",
            "!doc": ""
          }
        },
        "calls": {
          "!doc": "Every call to a spy is tracked and exposed on the calls property.",
          "any": {
            "!type": "fn() -> bool",
            "!doc": "returns false if the spy has not been called at all, and then true once at least one call happens."
          },
          "count": {
            "!type": "fn() -> number",
            "!doc": "returns the number of times the spy was called"
          },
          "argsFor": {
            "!type": "fn(index: number) -> [?]",
            "!doc": "returns the arguments passed to call number index"
          },
          "allArgs": {
            "!type": "fn() -> [[?]]",
            "!doc": "returns the arguments to all calls"
          },
          "all": {
            "!type": "fn() -> [?]",
            "!doc": "returns the context (the this) and arguments passed all calls"
          },
          "mostRecent": {
            "!type": "fn() -> !custom:call",
            "!doc": "returns the context (the this) and arguments for the most recent call"
          },
          "first": {
            "!type": "fn() -> !custom:call",
            "!doc": "returns the context (the this) and arguments for the first call"
          },
          "reset": {
            "!type": "fn()",
            "!doc": "clears all tracking for a spy"
          }
        }
      },
      "!jasmineClock": {
        "install": {
          "!type": "fn()",
          "!doc": "Installs a jasmine clock in a spec or suite that needs to manipulate time."
        },
        "uninstall": {
          "!type": "fn()",
          "!doc": "Uninstalls a jasmine clock"
        },
        "tick": {
          "!type": "fn(n: number)",
          "!doc": "Moves time forward"
        },
        "mockDate": {
          "!type": "fn(baseTime?: +Date)",
          "!doc": "Mocks the current date. If you do not provide a base time to mockDate it will use the current date."
        }
      }
    },
    "afterAll": {
      "!type": "fn(f: fn(done?: fn()))",
      "!effects": ["call !0 this=!self"],
      "!doc": "the afterAll function is called after all specs finish."
    },
    "afterEach": {
      "!type": "fn(f: fn(done?: fn()))",
      "!effects": ["call !0 this=!self"],
      "!doc": "To execute some code after every spec, simply put it in a afterEach. Note that you have to scope variables properly in order to have them throughout each spec"
    },
    "beforeAll": {
      "!type": "fn(f: fn(done?: fn()))",
      "!effects": ["call !0 this=!self"],
      "!doc": "The beforeAll function is called only once before all the specs in describe are run"
    },
    "beforeEach": {
      "!type": "fn(f: fn(done?: fn()))",
      "!effects": ["call !0 this=!self"],
      "!doc": "To execute some code before every spec, simply put it in a beforeEach. Note that you have to scope variables properly in order to have them throughout each spec"
    },
    "describe": {
      "!type": "fn(description: string, specDefinitions: fn())",
      "!effects": ["call !1 this=!self"],
      "!doc": "A test suite begins with a call to the global Jasmine function describe with two parameters: a string and a function. The string is a name or title for a spec suite - usually what is being tested. The function is a block of code that implements the suite."
    },
    "expect": {
      "!type": "fn(value: ?) -> !custom:jasmineExpect",
      "!doc": "Expectations are built with the function expect which takes a value, called the actual. It is chained with a Matcher function, which takes the expected value."
    },
    "fail": {
      "!type": "fn(message: string)",
      "!doc": "The fail function causes a spec to fail. It can take a failure message or an Error object as a parameter."
    },
    "it": {
      "!type": "fn(description: string, specDefinitions: fn(done?: fn()))",
      "!effects": ["call !1 this=!self"],
      "!doc": "Specs are defined by calling the global Jasmine function it, which, like describe takes a string and a function. The string is the title of the spec and the function is the spec, or test. A spec contains one or more expectations that test the state of the code. An expectation in Jasmine is an assertion that is either true or false. A spec with all true expectations is a passing spec. A spec with one or more false expectations is a failing spec."
    },
    "jasmine": {
      "addMatchers": {
        "!type": "fn(obj: ?)",
        "!doc": "Registers all properties on the object passed in as custom matchers"
      },
      "createSpy": {
        "!type": "fn(name: string) -> !custom:spyChaining",
        "!doc": "When there is not a function to spy on, jasmine.createSpy can create a “bare” spy. This spy acts as any other spy – tracking calls, arguments, etc."
      },
      "createSpyObj": {
        "!type": "fn(name: string, spies: [string]) -> !custom:spyChaining",
        "!doc": "When there is not a function to spy on, jasmine.createSpy can create a “bare” spy. This spy acts as any other spy – tracking calls, arguments, etc."
      },
      "any": {
        "!type": "fn(constructor: fn())",
        "!doc": "jasmine.any takes a constructor or “class” name as an expected value. It returns true if the constructor matches the constructor of the actual value."
      },
      "anything": {
        "!type": "fn()",
        "!doc": "jasmine.anything returns true if the actual value is not null or undefined."
      },
      "objectContaining": {
        "!type": "fn(pairs: +PlainObject)",
        "!doc": "jasmine.objectContaining is for those times when an expectation only cares about certain key/value pairs in the actual."
      },
      "arrayContaining": {
        "!type": "fn(values: [?])",
        "!doc": "jasmine.arrayContaining is for those times when an expectation only cares about some of the values in an array."
      },
      "stringMatching": {
        "!type": "fn(regex: +RegExp)",
        "!doc": "jasmine.stringMatching is for when you don’t want to match a string in a larger object exactly, or match a portion of a string in a spy expectation."
      },
      "clock": {
        "!type": "fn() -> !custom:jasmineClock",
        "!doc": "The Jasmine Clock is available for testing time dependent code."
      }
    },
    "pending": {
      "!type": "fn()",
      "!doc": "if you call this function anywhere in the spec body, no matter the expectations, the spec will be marked pending."
    },
    "spyOn": {
      "!type": "fn(value: ?) -> !custom:spyChaining",
      "!doc": "Registers a spy. Jasmine has test double functions called spies. A spy can stub any function and tracks calls to it and all arguments."
    }
  };

});
