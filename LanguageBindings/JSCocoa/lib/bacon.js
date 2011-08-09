_bacon_context = null;
_bacon_blocks = {};

function describe(name, body) {
  var before = _bacon_context;
  _bacon_context = JSBaconContext.alloc.initWithName(name);
  var context = _bacon_context;
  body.apply(context);
  _bacon_context = before;
  return context;
}

function it(name, body) {
  _bacon_blocks[body.toString()] = body;
  _bacon_context.addSpecification_withBlock_report(name, body.toString(), true);
}

function before(body) {
  _bacon_blocks[body.toString()] = body;
  _bacon_context.addBeforeFilter(body.toString());
}

function _bacon_eval(context, body) {
  _bacon_blocks[body].apply(context);
}

describe("Foo", function() {
  before(function() {
    this.banana = "Yummy!";
  });

  it("runs", function() {
    var o = NSObject.alloc.init;
    o.should.equal(o);
    o.should.not.equal(o);
  });

  it("has ivars", function() {
    log(this.banana);
    var f = function () {
      log("Aloha");
    }
    log(f.should);
  });
});
