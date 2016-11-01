(function(mod) {
  if (typeof exports == "object" && typeof module == "object") { // CommonJS
    return mod(require("tern/lib/infer"), require("tern/lib/tern"));
  }
  if (typeof define == "function" && define.amd) // AMD
    return define([ "tern/lib/infer", "tern/lib/tern" ], mod);
  mod(tern, tern);
})(function(infer, tern) {
  "use strict";

  tern.registerPlugin("sinon", function(server, options) {
    return {
      defs : defs,
    };
  });

  var defs = {
    "!name": "sinon",
    "!define": {
      "!spy": {
        "withArgs": {
          "!type": "fn(arg1: ?, arg2?: ?) -> !spy",
          "!doc": "Creates a spy that only records calls when the received arguments match those passed to withArgs.",
        },
        "callCount": {
          "!type": "number",
          "!doc": "The number of recorded calls.",
        },
        "called": {
          "!type": "bool",
          "!doc": "true if the spy was called at least once"
        },
        "calledOnce": {
          "!type": "bool",
          "!doc": "true if spy was called exactly once"
        },
        "calledTwice": {
          "!type": "bool",
          "!doc": "true if the spy was called exactly twice"
        },
        "calledThrice": {
          "!type": "bool",
          "!doc": "true if the spy was called exactly thrice"
        },
        "firstCall": {
          "!type": "!spyCall",
          "!doc": "The first call"
        },
        "secondCall": {
          "!type": "!spyCall",
          "!doc": "The second call"
        },
        "thirdCall": {
          "!type": "!spyCall",
          "!doc": "The third call"
        },
        "lastCall": {
          "!type": "!spyCall",
          "!doc": "The last call"
        },
        "calledBefore": {
          "!type": "fn(anotherSpy: !spy) -> bool",
          "!doc": "Returns true if the spy was called before anotherSpy"
        },
        "calledAfter": {
          "!type": "fn(anotherSpy: !spy) -> bool",
          "!doc": "Returns true if the spy was called after anotherSpy"
        },
        "calledOn": {
          "!type": "fn(obj: ?) -> bool",
          "!doc": "Returns true if the spy was called at least once with obj as this."
        },
        "alwaysCalledOn": {
          "!type": "fn(obj: ?) -> bool",
          "!doc": "Returns true if the spy was always called with obj as this."
        },
        "calledWith": {
          "!type": "fn(arg1: ?, arg2: ?) -> bool",
          "!doc": "Returns true if spy was called at least once with the provided arguments. Can be used for partial matching, Sinon only checks the provided arguments against actual arguments, so a call that received the provided arguments (in the same spots) and possibly others as well will return true."
        },
        "alwaysCalledWith": {
          "!type": "fn(arg1: ?, arg2: ?) -> bool",
          "!doc": "Returns true if spy was always called with the provided arguments (and possibly others)."
        },
        "calledWithExactly": {
          "!type": "fn(arg1: ?, arg2: ?) -> bool",
          "!doc": "Returns true if spy was called at least once with the provided arguments and no others."
        },
        "alwaysCalledWithExactly": {
          "!type": "fn(arg1: ?, arg2: ?) -> bool",
          "!doc": "Returns true if spy was always called with the exact provided arguments."
        },
        "calledWithMatch": {
          "!type": "fn(arg1: ?, arg2: ?) -> bool",
          "!doc": "Returns true if spy was called with matching arguments (and possibly others). This behaves the same as spy.calledWith(sinon.match(arg1), sinon.match(arg2), ...)."
        },
        "alwaysCalledWithMatch": {
          "!type": "fn(arg1: ?, arg2: ?) -> bool",
          "!doc": "Returns true if spy was always called with matching arguments (and possibly others). This behaves the same as spy.alwaysCalledWith(sinon.match(arg1), sinon.match(arg2), ...)."
        },
        "calledWithNew": {
          "!type": "fn() -> true",
          "!doc": "Returns true if spy/stub was called the new operator. Beware that this is inferred based on the value of the this object and the spy function’s prototype, so it may give false positives if you actively return the right kind of object."
        },
        "neverCalledWith": {
          "!type": "fn(arg1: ?, arg2: ?) -> bool",
          "!doc": "Returns true if the spy/stub was never called with the provided arguments."
        },
        "neverCalledWithMatch": {
          "!type": "fn(arg1: ?, arg2: ?) -> bool",
          "!doc": "Returns true if the spy/stub was never called with matching arguments. This behaves the same as spy.neverCalledWith(sinon.match(arg1), sinon.match(arg2), ...)."
        },
        "threw": {
          "!type": "fn() -> bool",
          "!doc": "Returns true if spy threw an exception at least once."
        },
        "alwaysThrew": {
          "!type": "fn() -> bool",
          "!doc": "Returns true if spy always threw an exception."
        },
        "returned": {
          "!type": "fn(obj: ?) -> true",
          "!doc": "Returns true if spy returned the provided value at least once. Uses deep comparison for objects and arrays. Use spy.returned(sinon.match.same(obj)) for strict comparison (see matchers)."
        },
        "alwaysReturned": {
          "!type": "fn(obj: ?) -> true",
          "!doc": "Returns true if spy always returned the provided value."
        },
        "getCall": {
          "!type": "fn(n: number) -> !spyCall",
          "!doc": "Returns the nth [call](#spycall). Accessing individual calls helps with more detailed behavior verification when the spy is called more than once. Example:"
        },
        "thisValues": {
          "!type": "[?]",
          "!doc": "Array of this objects, spy.thisValues[0] is the this object for the first call."
        },
        "args": {
          "!type": "[?]",
          "!doc": "Array of arguments received, spy.args[0] is an array of arguments received in the first call."
        },
        "exceptions": {
          "!type": "[?]",
          "!doc": "Array of exception objects thrown, spy.exceptions[0] is the exception thrown by the first call. If the call did not throw an error, the value at the call’s location in .exceptions will be ‘undefined’."
        },
        "returnValues": {
          "!type": "[?]",
          "!doc": "Array of return values, spy.returnValues[0] is the return value of the first call. If the call did not explicitly return a value, the value at the call’s location in .returnValues will be ‘undefined’."
        },
        "reset": {
          "!type": "fn()",
          "!doc": "Resets the state of a spy."
        },
        "printf": {
          "!type": "fn(format: string, args?: [?]) -> string",
          "!doc": "Returns the passed format string with the following replacements performed:"
        }
      },
      "!spyCall": {
        "calledOn": {
          "!type": "fn(obj: ?) -> bool",
          "!doc": "Returns true if obj was this for this call."
        },
        "calledWith": {
          "!type": "fn(arg1: ?, arg2?: ?) -> bool",
          "!doc": "Returns true if call received provided arguments (and possibly others)."
        },
        "calledWithExactly": {
          "!type": "fn(arg1: ?, arg2?: ?) -> bool",
          "!doc": "Returns true if call received provided arguments and no others."
        },
        "calledWithMatch": {
          "!type": "fn(arg1: ?, arg2?: ?) -> bool",
          "!doc": "Returns true if call received matching arguments (and possibly others). This behaves the same as spyCall.calledWith(sinon.match(arg1), sinon.match(arg2), ...)."
        },
        "notCalledWith": {
          "!type": "fn(arg1: ?, arg2?: ?) -> bool",
          "!doc": "Returns true if call did not receive provided arguments."
        },
        "notCalledWithMatch": {
          "!type": "fn(arg1: ?, arg2?: ?) -> bool",
          "!doc": "Returns true if call did not receive matching arguments. This behaves the same as spyCall.notCalledWith(sinon.match(arg1), sinon.match(arg2), ...)."
        },
        "threw": {
          "!type": "fn() -> bool",
          "!doc": "Returns true if call threw an exception."
        },
        "thisValue": {
          "!type": "?",
          "!doc": "The call’s this value."
        },
        "args": {
          "!type": "[?]",
          "!doc": "Array of received arguments."
        },
        "exception": {
          "!type": "?",
          "!doc": "Exception thrown, if any."
        },
        "returnValue": {
          "!type": "?",
          "!doc": "Return value."
        }
      },
      "!stub": {
        "withArgs": {
          "!type": "fn(arg1: ?, arg2?: ?) -> !stub",
          "!effects": ["copy !spy !stub"],
          "!doc": "Stubs the method only for the provided arguments. This is useful to be more expressive in your assertions, where you can access the spy with the same call."
        },
        "onCall": {
          "!type": "fn(n: number) -> !stub",
          "!effects": ["copy !spy !stub"],
          "!doc": "Defines the behavior of the stub on the nth call. Useful for testing sequential interactions."
        },
        "onFirstCall": {
          "!type": "fn() -> !stub",
          "!effects": ["copy !spy !stub"],
          "!doc": "Alias for stub.onCall(0)."
        },
        "onSecondCall": {
          "!type": "fn() -> !stub",
          "!effects": ["copy !spy !stub"],
          "!doc": "Alias for stub.onCall(1)."
        },
        "onThirdCall": {
          "!type": "fn() -> !stub",
          "!effects": ["copy !spy !stub"],
          "!doc": "Alias for stub.onCall(2)."
        },
        "returns": {
          "!type": "fn(obj: ?) -> !0",
          "!doc": "Makes the stub return the provided value."
        },
        "returnsArg": {
          "!type": "fn(index: number) -> ?",
          "!doc": "Causes the stub to return the argument at the provided index. stub.returnsArg(0); causes the stub to return the first argument."
        },
        "returnsThis": {
          "!type": "fn() -> ?",
          "!doc": "Causes the stub to return its this value. Useful for stubbing jQuery-style fluent APIs."
        },
        "throws": {
          "!type": "fn()",
          "!doc": "Causes the stub to throw an exception or exception of the provided type or the provided exception object."
        },
        "callsArg": {
          "!type": "fn(index: number)",
          "!doc": "Causes the stub to call the argument at the provided index as a callback function. stub.callsArg(0); causes the stub to call the first argument as a callback."
        },
        "callsArgOn": {
          "!type": "fn(index: number, context: ?)",
          "!doc": "Like above but with an additional parameter to pass the this context."
        },
        "callsArgWith": {
          "!type": "fn(index: number, arg1: ?, arg2: ?)",
          "!doc": "Like callsArg, but with arguments to pass to the callback."
        },
        "callsArgOnWith": {
          "!type": "fn(index: number, context: ?, arg1: ?, arg2: ?)",
          "!doc": "Like above but with an additional parameter to pass the this context."
        },
        "yields": {
          "!type": "fn(arg1?: ?, arg2?: ?)",
          "!doc": "Almost like callsArg. Causes the stub to call the first callback it receives with the provided arguments (if any). If a method accepts more than one callback, you need to use callsArg to have the stub invoke other callbacks than the first one."
        },
        "yieldsOn": {
          "!type": "fn(context: ?, arg1?: ?, arg2?: ?)",
          "!doc": "Like above but with an additional parameter to pass the this context."
        },
        "yieldsTo": {
          "!type": "fn(property: ?, arg1?: ?, arg2?: ?)",
          "!doc": "Causes the spy to invoke a callback passed as a property of an object to the spy. Like yields, yieldsTo grabs the first matching argument, finds the callback and calls it with the (optional) arguments."
        },
        "yieldsToOn": {
          "!type": "fn(property: ?, context: ?, arg1?: ?, arg2?: ?)",
          "!doc": "Like above but with an additional parameter to pass the this context."
        },
        "yield": {
          "!type": "fn(arg1?: ?, arg2?: ?)",
          "!doc": "Invoke callbacks passed to the stub with the given arguments. If the stub was never called with a function argument, yield throws an error. Also aliased as invokeCallback."
        },
        "yieldTo": {
          "!type": "fn(callback: ?, arg1?: ?, arg2?: ?)",
          "!doc": "Invokes callbacks passed as a property of an object to the spy. Like yield, yieldTo grabs the first matching argument, finds the callback and calls it with the (optional) arguments."
        },
        "callArg": {
          "!type": "fn(argNum: number)",
          "!doc": "Like yield, but with an explicit argument number specifying which callback to call. Useful if a function is called with more than one callback, and simply calling the first callback is not desired."
        },
        "callArgWith": {
          "!type": "fn(argNum: number, arg1?: ?, arg2?: ?)",
          "!doc": "Like `callArg`, but with arguments."
        },
        "callsArgAsync": {
          "!type": "fn(index: number)",
          "!doc": "Same as their corresponding non-Async counterparts, but with callback being deferred (executed not immediately but after short timeout and in another “thread”)"
        },
        "callsArgOnAsync": {
          "!type": "fn(index: number, context: ?)",
          "!doc": "Same as their corresponding non-Async counterparts, but with callback being deferred (executed not immediately but after short timeout and in another “thread”)"
        },
        "callsArgWithAsync": {
          "!type": "fn(index: number, arg1: ?, arg2: ?)",
          "!doc": "Same as their corresponding non-Async counterparts, but with callback being deferred (executed not immediately but after short timeout and in another “thread”)"
        },
        "callsArgOnWithAsync": {
          "!type": "fn(index: number, context: ?, arg1: ?, arg2: ?)",
          "!doc": "Same as their corresponding non-Async counterparts, but with callback being deferred (executed not immediately but after short timeout and in another “thread”)"
        },
        "yieldsAsync": {
          "!type": "fn(arg1?: ?, arg2?: ?)",
          "!doc": "Same as their corresponding non-Async counterparts, but with callback being deferred (executed not immediately but after short timeout and in another “thread”)"
        },
        "yieldsOnAsync": {
          "!type": "fn(context: ?, arg1?: ?, arg2?: ?)",
          "!doc": "Same as their corresponding non-Async counterparts, but with callback being deferred (executed not immediately but after short timeout and in another “thread”)"
        },
        "yieldsToAsync": {
          "!type": "fn(property: ?, arg1?: ?, arg2?: ?)",
          "!doc": "Same as their corresponding non-Async counterparts, but with callback being deferred (executed not immediately but after short timeout and in another “thread”)"
        },
        "yieldsToOnAsync": {
          "!type": "fn(property: ?, context: ?, arg1?: ?, arg2?: ?)",
          "!doc": "Same as their corresponding non-Async counterparts, but with callback being deferred (executed not immediately but after short timeout and in another “thread”)"
        }
      },
      "!expectation": {
        "atLeast": {
          "!type": "fn(n: number) -> !expectation",
          "!doc": "Specify the minimum amount of calls expected."
        },
        "atMost": {
          "!type": "fn(n: number) -> !expectation",
          "!doc": "Specify the maximum amount of calls expected."
        },
        "never": {
          "!type": "fn() -> !expectation",
          "!doc": "Expect the method to never be called."
        },
        "once": {
          "!type": "fn() -> !expectation",
          "!doc": "Expect the method to be called exactly once."
        },
        "twice": {
          "!type": "fn() -> !expectation",
          "!doc": "Expect the method to be called exactly twice."
        },
        "thrice": {
          "!type": "fn() -> !expectation",
          "!doc": "Expect the method to be called exactly thrice."
        },
        "exactly": {
          "!type": "fn(n: number) -> !expectation",
          "!doc": "Expect the method to be called exactly number times."
        },
        "withArgs": {
          "!type": "fn(arg1: ?, arg2: ?) -> !expectation",
          "!doc": "Expect the method to be called with the provided arguments and possibly others."
        },
        "withExactArgs": {
          "!type": "fn(arg1: ?, arg2: ?) -> !expectation",
          "!doc": "Expect the method to be called with the provided arguments and no others."
        },
        "on": {
          "!type": "fn(obj: ?) -> !expectation",
          "!doc": "Expect the method to be called with obj as this."
        },
        "verify": {
          "!type": "fn()",
          "!doc": "Verifies the expectation and throws an exception if it’s not met."
        },
        "expects": {
          "!type": "fn(method: string) -> !expectation",
          "!doc": "Overrides obj.method with a mock function and returns it."
        },
        "restore": {
          "!type": "fn()",
          "!doc": "Restores all mocked methods."
        },
      },
      "!clock": {
        "tick": {
          "!type": "fn(ms: number)",
          "!doc": "Tick the clock ahead ms milliseconds. Causes all timers scheduled within the affected time range to be called."
        },
        "restore": {
          "!type": "fn()",
          "!doc": "Restore the faked methods. Call in e.g. tearDown."
        }
      },
      "!xhr": {
        "onCreate": {
          "!doc": "By assigning a function to the onCreate property of the returned object from useFakeXMLHttpRequest() you can subscribe to newly created FakeXMLHttpRequest objects."
        },
        "restore": {
          "!type": "fn()",
          "!doc": "Restore original function(s)."
        }
      },
      "!server": {
        "configure": {
          "!type": "fn(confing: ?)",
          "!doc": "Configures the fake server. See options below for configuration parameters."
        },
        "respondWith": {
          "!type": "fn()",
          "!doc": "response can be on of three things:"
        },
        "respond": {
          "!type": "fn()",
          "!doc": "Causes all queued asynchronous requests to receive a response. If none of the responses added through respondWith match, the default response is [404, {}, '']. Synchronous requests are responded to immediately, so make sure to call respondWith upfront. If called with arguments, respondWith will be called with those arguments before responding to requests."
        },
        "autoRespond": {
          "!type": "bool",
          "!doc": "If set, will automatically respond to every request after a timeout. The default timeout is 10ms but you can control it through the autoRespondAfter property. Note that this feature is intended to help during mockup development, and is not suitable for use in tests. For synchronous immediate responses, use respondImmediately instead."
        },
        "autoRespondAfter": {
          "!type": "number",
          "!doc": "Causes the server to automatically respond to incoming requests after a timeout."
        },
        "respondImmediately": {
          "!type": "bool",
          "!doc": "If set, the server will respond to every request immediately and synchronously. This is ideal for faking the server from within a test without having to call server.respond() after each request made in that test. As this is synchronous and immediate, this is not suitable for simulating actual network latency in tests or mockups. To simulate network latency with automatic responses, see server.autoRespond and server.autoRespondAfter."
        },
        "fakeHTTPMethods": {
          "!type": "bool",
          "!doc": "If set to true, server will find _method parameter in POST body and recognize that as the actual method. Supports a pattern common to Ruby on Rails applications. For custom HTTP method faking, override server.getHTTPMethod(request)."
        },
        "getHTTPMethod": {
          "!type": "fn(request: ?)",
          "!doc": "Used internally to determine the HTTP method used with the provided request. By default this method simply returns request.method. When server.fakeHTTPMethods is true, the method will return the value of the _method parameter if the method is “POST”. This method can be overrided to provide custom behavior."
        },
        "restore": {
          "!type": "fn()",
          "!doc": "Restores the native XHR constructor."
        }
      },
      "!sandbox": {
        "spy": {
          "!type": "fn()",
          "!doc": "Works exactly like sinon.spy, only also adds the returned spy to the internal collection of fakes for easy restoring through sandbox.restore()."
        },
        "stub": {
          "!type": "fn()",
          "!doc": "Works almost exactly like sinon.stub, only also adds the returned stub to the internal collection of fakes for easy restoring through sandbox.restore(). The sandbox stub method can also be used to stub any kind of property. This is useful if you need to override an object’s property for the duration of a test, and have it restored when the test completes."
        },
        "mock": {
          "!type": "fn()",
          "!doc": "Works exactly like sinon.mock, only also adds the returned mock to the internal collection of fakes for easy restoring through sandbox.restore()."
        },
        "useFakeTimers": {
          "!type": "fn()",
          "!doc": "Fakes timers and binds the clock object to the sandbox such that it too is restored when calling sandbox.restore(). Access through sandbox.clock."
        },
        "useFakeXMLHttpRequest": {
          "!type": "fn()",
          "!doc": "Fakes XHR and binds the resulting object to the sandbox such that it too is restored when calling sandbox.restore(). Access requests through sandbox.requests."
        },
        "useFakeServer": {
          "!type": "fn()",
          "!doc": "Fakes XHR and binds a server object to the sandbox such that it too is restored when calling sandbox.restore(). Access requests through sandbox.requests and server through sandbox.server."
        },
        "restore": {
          "!type": "fn()",
          "!doc": "Restores all fakes created through sandbox."
        }
      }
    },
    "sinon": {
      "spy": {
        "!type": "fn(toSpy?: ?, method?: string) -> !spy",
        "!doc": "A test spy is a function that records arguments, return value, the value of this and exception thrown (if any) for all its calls."
      },
      "stub": {
        "!type": "fn(obj?: ?, method?: string, func?: fn() -> !spy) -> !stub",
        "!effects": ["copy !spy !stub"],
        "!doc": "Test stubs are functions (spies) with pre-programmed behavior."
      },
      "mock": {
        "!type": "fn() -> !expectation",
        "!doc": "Creates an expectation without a mock object, basically an anonymous mock function."
      },
      "expectation": {
        "create": {
          "!type": "fn(methodName?: string) -> !expectation",
          "!doc": "Creates an expectation without a mock object, basically an anonymous mock function. Method name is optional and is used in exception messages to make them more readable."
        },
      },
      "useFakeTimers": {
        "!type": "fn() -> !clock",
        "!doc": "Causes Sinon to replace the global setTimeout, clearTimeout, setInterval, clearInterval and Date with a custom implementation which is bound to the returned clock object."
      },
      "useFakeXMLHttpRequest": {
        "!type": "fn() -> !xhr",
        "!doc": "Causes Sinon to replace the native XMLHttpRequest object in browsers that support it with a custom implementation which does not send actual requests."
      },
      "fakeServer": {
        "create": {
          "!type": "fn(config?: ?) -> !server",
          "!doc": "Creates a new server. This function also calls sinon.useFakeXMLHttpRequest(). create accepts optional properties to configure the fake server."
        }
      },
      "fakeServerWithClock": {
        "create": {
          "!type": "fn() -> !server",
          "!doc": "Creates a server that also manages fake timers. This is useful when testing XHR objects created with e.g. jQuery 1.3.x, which uses a timer to poll the object for completion, rather than the usual onreadystatechange."
        }
      },
      "assert": {
        "fail": {
          "!type": "fn(message: string)",
          "!doc": "Every assertion fails by calling this method. By default it throws an error of type sinon.assert.failException. If your testing framework looks for assertion errors by checking for a specific exception, you can simply override the kind of exception thrown. If that does not fit with your testing framework of choice, override the fail method to do the right thing."
        },
        "failException": {
          "!doc": "Defaults to 'AssertError'."
        },
        "pass": {
          "!type": "fn(assertion: sinon.assert)",
          "!doc": "Called every time an assertion passes. Default implementation does nothing."
        },
        "notCalled": {
          "!type": "fn(spy: ?)",
          "!doc": "Passes if spy was never called."
        },
        "called": {
          "!type": "fn(spy: ?)",
          "!doc": "Passes if spy was called at least once."
        },
        "calledOnce": {
          "!type": "fn(spy: ?)",
          "!doc": "Passes if spy was called once and only once."
        },
        "calledTwice": {
          "!type": "fn(spy: !spy)",
          "!doc": "Passes if spy was called exactly twice."
        },
        "calledThrice": {
          "!type": "fn(spy: ?)",
          "!doc": "Passes if spy was called exactly three times."
        },
        "callCount": {
          "!type": "fn(spy: ?, num: number)",
          "!doc": "Passes if the spy was called exactly num times."
        },
        "callOrder": {
          "!type": "fn(spy1: ?, spy2: ?)",
          "!doc": "Passes if the provided spies where called in the specified order."
        },
        "calledOn": {
          "!type": "fn(spy: ?, obj: ?)",
          "!doc": "Passes if the spy was ever called with obj as its this value."
        },
        "alwaysCalledOn": {
          "!type": "fn(spy: ?, obj: ?)",
          "!doc": "Passes if the spy was always called with obj as its this value."
        },
        "calledWith": {
          "!type": "fn(spy: ?, arg1: ?, arg2: ?)",
          "!doc": "Passes if the spy was called with the provided arguments."
        },
        "alwaysCalledWith": {
          "!type": "fn(spy: ?, arg1: ?, arg2: ?)",
          "!doc": "Passes if the spy was always called with the provided arguments."
        },
        "neverCalledWith": {
          "!type": "fn(spy: ?, arg1: ?, arg2: ?)",
          "!doc": "Passes if the spy was never called with the provided arguments."
        },
        "calledWithExactly": {
          "!type": "fn(spy: ?, arg1: ?, arg2: ?)",
          "!doc": "Passes if the spy was called with the provided arguments and no others."
        },
        "alwaysCalledWithExactly": {
          "!type": "fn(spy: ?, arg1: ?, arg2: ?)",
          "!doc": "Passes if the spy was always called with the provided arguments and no others."
        },
        "calledWithMatch": {
          "!type": "fn(spy: ?, arg1: ?, arg2: ?)",
          "!doc": "Passes if the spy was called with matching arguments. This behaves the same as sinon.assert.calledWith(spy, sinon.match(arg1), sinon.match(arg2), ...)."
        },
        "alwaysCalledWithMatch": {
          "!type": "fn(spy: ?, arg1: ?, arg2: ?)",
          "!doc": "Passes if the spy was always called with matching arguments. This behaves the same as sinon.assert.alwaysCalledWith(spy, sinon.match(arg1), sinon.match(arg2), ...)."
        },
        "neverCalledWithMatch": {
          "!type": "fn(spy: ?, arg1: ?, arg2: ?)",
          "!doc": "Passes if the spy was never called with matching arguments. This behaves the same as sinon.assert.neverCalledWith(spy, sinon.match(arg1), sinon.match(arg2), ...)."
        },
        "threw": {
          "!type": "fn(spy: ?, exception: ?)",
          "!doc": "Passes if the spy threw the given exception. The exception can be a string denoting its type, or an actual object. If only one argument is provided, the assertion passes if the spy ever threw any exception."
        },
        "alwaysThrew": {
          "!type": "fn(spy: ?, exception: ?)",
          "!doc": "Like above, only required for all calls to the spy."
        },
        "expose": {
          "!type": "fn(object: ?, options: ?)",
          "!doc": "Exposes assertions into another object, to better integrate with the test framework."
        }
      },
      "match": {
        "any": {
          "!type": "?",
          "!doc": "Matches anything."
        },
        "defined": {
          "!type": "?",
          "!doc": "Requires the value to be defined."
        },
        "truthy": {
          "!type": "bool",
          "!doc": "Requires the value to be truthy."
        },
        "falsy": {
          "!type": "bool",
          "!doc": "Requires the value to be falsy."
        },
        "bool": {
          "!type": "bool",
          "!doc": "Requires the value to be a boolean."
        },
        "number": {
          "!type": "number",
          "!doc": "Requires the value to be a number."
        },
        "string": {
          "!type": "string",
          "!doc": "Requires the value to be a string."
        },
        "object": {
          "!type": "?",
          "!doc": "Requires the value to be an object."
        },
        "func": {
          "!type": "fn()",
          "!doc": "Requires the value to be a function."
        },
        "array": {
          "!type": "[?]",
          "!doc": "Requires the value to be an array."
        },
        "regexp": {
          "!type": "+RegExp",
          "!doc": "Requires the value to be a regular expression."
        },
        "date": {
          "!type": "+Date",
          "!doc": "Requires the value to be a date object."
        },
        "same": {
          "!type": "fn(ref: ?)",
          "!doc": "Requires the value to strictly equal ref."
        },
        "typeOf": {
          "!type": "fn(type: ?)",
          "!doc": "Requires the value to be of the given type, where type can be one of 'undefined', 'null', 'boolean', 'number', 'string', 'object', 'function', 'array', 'regexp' or 'date'."
        },
        "instanceOf": {
          "!type": "fn(type: ?)",
          "!doc": "Requires the value to be an instance of the given type."
        },
        "has": {
          "!type": "fn(property: ?, expectation?: ?)",
          "!doc": "Requires the value to define the given property. The property might be inherited via the prototype chain. If the optional expectation is given, the value of the property is deeply compared with the expectation. The expectation can be another matcher."
        },
        "hasOwn": {
          "!type": "fn(property: ?, expectation?: ?)",
          "!doc": "Same as sinon.match.has but the property must be defined by the value itself. Inherited properties are ignored."
        }
      },
      "sandbox": {
        "create": {
          "!type": "fn(config?: ?) -> !sandbox",
          "!doc": "Creates a sandbox object"
        }
      },
      "test": {
        "!type": "fn(fn: fn())",
        "!effects": ["call !0 this=sinon"],
        "!doc": "Wrapping test methods in `sinon.test` allows Sinon.JS to automatically create and manage sandboxes for you."
      },
      "testCase": {
        "!type": "fn()",
        "!doc": "If you need the behavior of `sinon.test` for more than one test method in a test case, you can use `sinon.testCase`, which behaves exactly like wrapping each test in `sinon.test` with one exception: `setUp` and `tearDown` can share fakes."
      },
      "createStubInstance": {
        "!type": "fn(constructor: ?)",
        "!doc": "Creates a new object with the given function as the protoype and stubs all implemented functions. The given constructor function is not invoked."
      },
      "format": {
        "!type": "fn(object: ?) -> string",
        "!doc": "Formats an object for pretty printing in error messages."
      },
      "log": {
        "!type": "fn(string)",
        "!doc": "Logs internal errors, helpful for debugging."
      }
    }
  };

});
