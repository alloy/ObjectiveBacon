(if nil
(try (load "ObjectiveBacon:bacon"))

(macro catch-failure (block)
  `(try
    ,block
    (catch (e)
      (set failure e)
    )
  )
)

(macro createSpecification (description block report)
  `((BaconSpecification alloc) initWithContext:dummyContext
                                 description:,description
                                       block:,block
                                      before:emptyArray
                                       after:emptyArray
                                      report:,report)
)

; Hooray for meta-testing.
(set succeed
  (do (block)
    (((send block should) not) raise:BaconError)
    t
  )
)

(set fail
  (do (block)
    ((send block should) raise:BaconError)
    t
  )
)

(class DummyContext is NSObject
  (- (id)name is "Dummy context")
  (- (id)evaluateBlock:(id)block is (self instanceEval:block))
  (- (id)specificationDidFinish:(id)spec is
    ; noop
  )
)

; Just some test constants
(set equalFoo (do (x) (eq x "foo")))
(set equalBar (do (x) (eq x "bar")))
(set aRequirement ("foo" should))
(set emptyArray (NSArray array))
(set notEmptyArray (`("foo") array))
(set dummyContext (DummyContext new))

(describe "An instance of BaconShould" `(
  (it "raises a BaconError if the assertion fails" (do ()
    (-> (~ "foo" should equal:"bar") should:fail)
  ))
  
  (it "does not raise an exception if the assertion passes" (do ()
    (-> (~ "foo" should equal:"foo") should:succeed)
  ))
  
  (it "catches any type of exception so the spec suite can continue" (do ()
    (-> ((createSpecification "throws" (do () throw "ohnoes") nil) run) should not raise)
  ))
  
  ; NOTE: this requirement will print that the requirement failed/flunked, but in fact it does not!
  (it "flunks a requirement if it contains no assertions" (do ()
    (set numberOfFailuresBefore (((Bacon sharedInstance) summary) failures))
    ((createSpecification "flunks" (do ()) t) run)
    (~ (((Bacon sharedInstance) summary) failures) should equal:(+ numberOfFailuresBefore 1))
    (((Bacon sharedInstance) summary) setFailures:numberOfFailuresBefore)
  ))
  
  (it "checks if the given block satisfies" (do ()
    (-> (~ "foo" should satisfy:"pass" block:equalFoo) should:succeed)
    (-> (~ "foo" should satisfy:"fail" block:equalBar) should:fail)
    (-> (~ "foo" should not satisfy:"pass" block:equalBar) should:succeed)
    (-> (~ "foo" should not satisfy:"fail" block:equalFoo) should:fail)
  ))
  
  (it "negates an assertion" (do ()
    (-> (~ "foo" should not equal:"bar") should:succeed)
    (-> (~ "foo" should not equal:"foo") should:fail)
  ))
  
  (it "has `be', `a', and `an' syntactic sugar methods which add to the requirement description and return the BaconShould instance" (do ()
    (aRequirement setValue:"" forIvar:"descriptionBuffer")
    (~ (eq (aRequirement be) aRequirement) should be:t)
    (~ (aRequirement valueForIvar:"descriptionBuffer") should equal:" be")
    (~ (eq (aRequirement a) aRequirement) should be:t)
    (~ (aRequirement valueForIvar:"descriptionBuffer") should equal:" be a")
    (~ (eq (aRequirement an) aRequirement) should be:t)
    (~ (aRequirement valueForIvar:"descriptionBuffer") should equal:" be a an")
  ))
  
  ; TODO these segfault on an iOS device (iPhone 3GS at least)
  (if (or (not TARGET_OS_IPHONE) TARGET_IPHONE_SIMULATOR)
    (it "has a `be:' syntactic sugar method which checks for equality" (do ()
      ((-> (aRequirement be:"foo")) should:succeed)
      ((-> (aRequirement be:"bar")) should:fail)
    ))
    
    (it "has a `be:' syntactic sugar method which takes a block which in turn is passed to satisfy:block:" (do ()
      (-> (aRequirement be:(do (_) t)) should:succeed)
      (-> (aRequirement be:(do (_) nil)) should:fail)
    ))
    
    (it "has a `a:' syntactic sugar method which checks for equality" (do ()
      (-> (aRequirement a:"foo") should:succeed)
      (-> (aRequirement a:"bar") should:fail)
    ))
    
    (it "has a `a:' syntactic sugar method which takes a block which in turn is passed to satisfy:block:" (do ()
      (-> (aRequirement a:(do (_) t)) should:succeed)
      (-> (aRequirement a:(do (_) nil)) should:fail)
    ))
  )
  
  (it "checks for equality" (do ()
    (-> (~ "foo" should equal:"foo") should:succeed)
    (-> (~ "foo" should not equal:"foo") should:fail)
  ))
  
  (it "checks if the number is close to a given number" (do ()
    (-> (~ 1.4 should be closeTo:1.4) should:succeed)
    (-> (~ 0.4 should be closeTo:0.5 delta:0.1) should:succeed)
    (-> (~ 0.4 should be closeTo:0.5) should:fail)
    (-> (~ 0.4 should be closeTo:0.5 delta:0.05) should:fail)
  ))
  
  (it "checks if the numbers in the list are close to the list of given numbers" (do ()
    (-> (~ (`(1.4 2.5 3.6 4.7) array) should be closeTo:(`(1.4 2.5 3.6 4.7) array)) should:succeed)
    (-> (~ (`(1.4 2.5 3.6 4.7) array) should be closeTo:(`(1.4 2.6 3.6 4.7) array)) should:fail)
    (-> (~ (`(1.4 2.5 3.6 4.7) array) should be closeTo:(`(1.4 2.6 3.6 4.7) array) delta:0.1) should:succeed)
  ))
  
  (it "checks if the string matches the given regexp" (do ()
    (-> (~ "string" should match:/strin./) should:succeed)
    (-> (~ "string" should match:/slin./) should:fail)
    (-> (~ "string" should not match:/slin./) should:succeed)
    (-> (~ "string" should not match:/strin./) should:fail)
  ))
  
  ;(it "checks if after executing a block a numeric value has changed at all" (do ()
    ;(set x 0)
    ;(set valueBlock (do () x)) ; simply returns the value of x
    ;(-> (-> (set x (+ x 1)) should change:valueBlock) should:succeed)
    ;(-> (-> (set x x)       should change:valueBlock) should:fail)
    ;(-> (-> (set x x)       should not change:valueBlock) should:succeed)
    ;(-> (-> (set x (+ x 1)) should not change:valueBlock) should:fail)
  ;))
  
  ;(it "checks if after executing a block a numeric value has changed by a given delta" (do ()
    ;(set x 0)
    ;(set valueBlock (do () x)) ; simply returns the value of x
    ;(-> (-> (set x (+ x 1)) should change:valueBlock by:+1) should:succeed)
    ;(-> (-> (set x (+ x 2)) should change:valueBlock by:+1) should:fail)
    ;(-> (-> (set x (- x 1)) should change:valueBlock by:-1) should:succeed)
    ;(-> (-> (set x (- x 2)) should change:valueBlock by:-1) should:fail)
    ;(-> (-> (set x (+ x 1)) should not change:valueBlock by:-1) should:succeed)
    ;(-> (-> (set x (+ x 1)) should not change:valueBlock by:+1) should:fail)
  ;))
  
  (it "checks if any exception is raised" (do ()
    (-> (emptyArray objectAtIndex:0) should raise)
    (-> (notEmptyArray objectAtIndex:0) should not raise)
  ))
  
  (it "checks if a specified exception is raised" (do ()
    (-> (emptyArray objectAtIndex:0) should raise:"NSRangeException")
    (-> (-> (emptyArray objectAtIndex:0) should not raise:"SomeRandomException") should raise:"NSRangeException")
  ))
  
  (it "returns the raised exception" (do ()
    (set e (-> (emptyArray objectAtIndex:0) should raise:"NSRangeException"))
    (~ ((e class) name) should equal:"NuException")
    (~ (e name) should equal:"NSRangeException")
  ))
  
  (it "checks if the object has the method and, if so, forward the message" (do ()
    (-> (~ "/an/absolute/path" should be isAbsolutePath) should:succeed)
    (-> (~ "a/relative/path" should be isAbsolutePath) should:fail)
  ))
  
  (it "checks if the object has a predicate version of the method and if so forward the message" (do ()
    (-> (~ "/an/absolute/path" should be an absolutePath) should:succeed)
    (-> (~ "a/relative/path" should be an absolutePath) should:fail)
  ))
  
  (it "checks if the object has the third person version of the method and if so forward the message" (do ()
    (-> (~ "foo" should respondToSelector:"isAbsolutePath") should:succeed)
    (-> (~ "foo" should not respondToSelector:"noWay") should:succeed)
    (-> (~ "foo" should respondToSelector:"noWay") should:fail)
    (-> (~ "foo" should not respondToSelector:"isAbsolutePath") should:fail)
  ))
  
  (unless ((Bacon sharedInstance) skipRequirementsThatRaiseExceptions)
    (it "creates nice descriptions" (do ()
      (catch-failure (~ "foo" should be:42))
      (~ (failure reason) should equal:"expected `foo' to be `42'")
      
      (catch-failure (~ 0.4 should be closeTo:42))
      (~ (failure reason) should equal:"expected `0.4' to be close to `42'")
      
      (catch-failure (~ "foo" should not equal:"foo"))
      (~ (failure reason) should equal:"expected `foo' to not equal `foo'")
      
      (catch-failure (~ "foo" should match:/slin./))
      (~ (failure reason) should equal:"expected `foo' to match /slin./")
      
      ;(set x 0)
      ;(set valueBlock (do () x)) ; simply returns the value of x
      ;(catch-failure (-> (set x x) should change:valueBlock))
      ;(~ (failure reason) should equal:"expected `(do () ((set x x)))' to change `(x)'")
      ;(catch-failure (-> (set x x) should change:valueBlock by:-1))
      ;(~ (failure reason) should equal:"expected `(do () ((set x x)))' to change `(x)' by `-1'")
      
      (set o1 (NSObject new))
      (set o2 (NSObject new))
      (catch-failure (~ o1 should equal:o2))
      (~ (failure reason) should equal:"expected `#{(o1 description)}' to equal `#{(o2 description)}'")
      
      (set otherArray (`("bar") array))
      (catch-failure (~ notEmptyArray should equal:otherArray))
      (~ (failure reason) should equal:"expected `#{(notEmptyArray class)}: #{(notEmptyArray description)}' to equal `#{(otherArray class)}: #{(otherArray description)}'")
      
      (catch-failure (~ "foo" should be isEqualToString:"bar"))
      (~ (failure reason) should equal:"expected `foo' to be isEqualToString: with `bar'")
      
      (catch-failure (~ "foo" should equalToString:"bar"))
      (~ (failure reason) should equal:"expected `foo' to equalToString: with `bar'")
      
      (catch-failure (~ "foo" should be an absolutePath))
      (~ (failure reason) should equal:"expected `foo' to be an absolutePath")
      
      (catch-failure (~ "foo" should satisfy:nil block:(do (x) (eq x "bar"))))
      (~ (failure reason) should equal:"expected `foo' to satisfy `(do (x) ((eq x \"bar\")))'")
      
      (catch-failure (~ "foo" should:(do (x) (eq x "bar"))))
      (~ (failure reason) should equal:"expected `foo' to satisfy `(do (x) ((eq x \"bar\")))'")
      
      (catch-failure (~ "foo" should not:(do (x) (eq x "foo"))))
      (~ (failure reason) should equal:"expected `foo' to not satisfy `(do (x) ((eq x \"foo\")))'")
    ))
  )
))

(class BaconContext
  (- (id)delegateCallbackMethod is
    (set @delegateCallbackCalled t)
    (self resume)
  )

  (- (id)delegateCallbackTookTooLongMethod is
    (throw "Oh noes, I must never be called!")
  )

  (- (id)triggerChange is
    (@observable setAnAttribute:"changed")
  )
)

(class MockObservable is NSObject
  (ivar (id) anAttribute)

  (- (id)anAttribute is
    @anAttribute
  )

  (- (void)setAnAttribute:(id)value is
    (set @anAttribute value)
  )
)

(describe "The NuBacon helper macros" `(
  (it "includes the `~' macro, which dynamically dispatches the messages, in an unordered list, to the first object in the list" (do ()
    (-> (~ "foo" should be a kindOfClass:NSCFString) should:succeed)
    (-> (~ "foo" should not equal:"foo") should:fail)
  ))

  (describe "concerning the `->' macro" `(
    (it "is a shortcut for creating a block and returning a BaconShould instance for said block" (do ()
      (set @ivar "foo")
      (set lvar  "foo")
      (set ran  nil)

      (set result (-> (set ran (eq @ivar lvar))))

      (~ ((result class) name) should be:"BaconShould")
      (~ (send (result object) body) should equal:`((set ran (eq @ivar lvar))))
      (~ result should not raise) ; executes the block
      (~ ran should be:t)
    ))

    (it "forwards any extra messages to the `~' macro" (do ()
      (-> (-> (throw "oh noes") should not raise) should:fail)
    ))
  ))

  (describe "concerning NSRunloop aware macros" `(
    (describe "concerning `wait' with a fixed time" `(
      (it "allows the user to postpone execution of a block for n seconds, which will halt any further execution of specs" (do ()
        (set startedAt1 (NSDate date))
        (set startedAt2 (NSDate date))
        (set startedAt3 (NSDate date))
        (set numberOfSpecsBefore (((Bacon sharedInstance) summary) specifications))

        (wait 0.5 (do ()
          (~ ((NSDate date) timeIntervalSinceDate:startedAt1) should be closeTo:0.5 delta:0.1)
        ))
        (wait 1 (do ()
          (~ ((NSDate date) timeIntervalSinceDate:startedAt2) should be closeTo:1 delta:0.1)
          (wait 1.5 (do ()
            (~ ((NSDate date) timeIntervalSinceDate:startedAt3) should be closeTo:2.5 delta:0.1)
            ; no other specs should have ran in the meantime!
            (~ (((Bacon sharedInstance) summary) specifications) should be:numberOfSpecsBefore)
          ))
        ))
      ))
    ))

    (describe "concerning `wait' without a fixed time" `(
      (it "allows the user to postpone execution of a block until Context#resume is called, from for instance a delegate callback" (do ()
        (self performSelector:"delegateCallbackMethod" withObject:nil afterDelay:0.1)
        (wait (do ()
          (~ @delegateCallbackCalled should be:t)
        ))
      ))

      (before (do ()
        (set failures (((Bacon sharedInstance) summary) failures))
        (unless (eq @failuresBefore nil)
          (then
            (((Bacon sharedInstance) summary) setFailures:@failuresBefore)
            (~ failures should be:(+ @failuresBefore 1))
          )
          (else (set @failuresBefore failures))
        )
      ))

      ; This spec adds a failure to the ErrorLog!
      (it "has a default timeout of 1 second after which the spec will fail and further scheduled calls to the Context are cancelled" (do ()
        (self performSelector:"delegateCallbackTookTooLongMethod" withObject:nil afterDelay:1.2)
        (wait (do ()
          ; we must never arrive here, because the default timeout of 1 second will have passed
          (throw "Oh noes, we shouldn't have arrived in this postponed block!")
        ))
      ))

      ; This spec adds a failure to the ErrorLog!
      (it "takes an explicit timeout" (do ()
        (self performSelector:"delegateCallbackTookTooLongMethod" withObject:nil afterDelay:0.8)
        (wait-max 0.3 (do ()
          ; we must never arrive here, because the default timeout of 1 second will have passed
          (throw "Oh noes, we shouldn't have arrived in this postponed block!")
        ))
      ))

      (it "runs an extra spec so that the before filter runs one more time" (do ()
        (~ t should be:t)
      ))
    ))

    (describe "concerning `wait_for_change'" `(
      (before (do ()
        (set @observable (MockObservable new))
      ))

      (it "resumes the postponed block once an observed value changes" (do ()
        (wait-for-change @observable "anAttribute" (do ()
          (set @value (@observable anAttribute))
        ))
        (~ @value should be:nil)
        (self performSelector:"triggerChange" withObject:nil afterDelay:0.1)
        (wait 0.2 (do ()
          (~ @value should be:"changed")
        ))
      ))

      (before (do ()
        (set failures (((Bacon sharedInstance) summary) failures))
        (unless (eq @failuresBefore nil)
          (then
            (((Bacon sharedInstance) summary) setFailures:@failuresBefore)
            (~ failures should be:(+ @failuresBefore 1))
          )
          (else (set @failuresBefore failures))
        )
      ))

      ; This spec adds a failure to the ErrorLog!
      (it "has a default timeout of 1 second" (do ()
        (wait-for-change @observable "anAttribute" (do ()
          (throw "Oh noes, I must never be called!")
        ))
        (self performSelector:"triggerChange" withObject:nil afterDelay:1.1)
        (wait 1.2 (do ()
          ; we must never arrive here, because the default timeout of 1 second will have passed
          (throw "Oh noes, we shouldn't have arrived in this postponed block!")
        ))
      ))

      ; This spec adds a failure to the ErrorLog!
      (it "takes an explicit timeout" (do ()
        (wait-for-change @observable "anAttribute" 0.3 (do ()
          (throw "Oh noes, I must never be called!")
        ))
        (self performSelector:"triggerChange" withObject:nil afterDelay:0.8)
        (wait 0.9 (do ()
          ; we must never arrive here, because the default timeout of 1 second will have passed
          (throw "Oh noes, we shouldn't have arrived in this postponed block!")
        ))
      ))

      (it "runs an extra spec so that the before filter runs one more time" (do ()
        (~ t should be:t)
      ))
    ))
  ))

  ; TODO add the before/after wait specs that are present in the MacRuby specs.
))

(describe "NSObject, concerning Bacon extensions" `(
  (it "returns a BaconShould instance, wrapping that object" (do ()
    (~ "foo" should equal:"foo")
  ))
  
  (it "takes a block that's to be called with the `object', the return value indicates success or failure" (do ()
    (-> (~ "foo" should:equalFoo) should:succeed)
    (-> (~ "foo" should:equalBar) should:fail)
    (-> (~ "foo" should not:equalBar) should:succeed)
    (-> (~ "foo" should not:equalFoo) should:fail)
  ))
))

(describe "before/after" `(
  (before (do ()
    (set @a 1)
    (set @b 2)
  ))
  
  (before (do ()
    (set @a 2)
  ))
  
  (after (do ()
    (~ @a should equal:2)
    (set @a 3)
  ))
  
  (after (do ()
    (~ @a should equal:3)
  ))
  
  (it "runs in the right order" (do ()
    (~ @a should equal:2)
    (~ @b should equal:2)
  ))
  
  (describe "when nested" `(
    (before (do ()
      (set @c 5)
    ))
    
    (it "runs from higher level" (do ()
      (~ @a should equal:2)
      (~ @b should equal:2)
    ))
    
    (it "runs at the nested level" (do ()
      (~ @c should equal:5)
    ))
    
    (before (do ()
      (set @a 5)
    ))
    
    (it "runs in the right order" (do ()
      (~ @a should equal:5)
      (set @a 2)
    ))
  ))
  
  (it "does not run from lower level" (do ()
    (~ @c should be:nil)
  ))
  
  (describe "when nested at a sibling level" `(
    (it "does not run from sibling level" (do ()
      (~ @c should be:nil)
    ))
  ))
))

(shared "a shared context" `(
  (it "gets called where it is included" (do ()
    (~ t should be:t)
  ))
))

(shared "another shared context" `(
  (it "can access data" (do ()
    (~ @magic should be:42)
  ))
))

(describe "shared/behaves_like" `(
  (behaves_like "a shared context")
  
  (it "raises when the context is not found" (do ()
    (set e (-> (behaves_like "whoops") should raise))
    (~ e should equal:"No such context `whoops'")
  ))
  
  (behaves_like "a shared context")
  
  (before (do ()
    (set @magic 42)
  ))
  
  (behaves_like "another shared context")
))


(describe "Regression specs" `(
  (describe "An empty context does not break, issue #5" `(
    ; EMPTY
  ))

  (unless TARGET_OS_IPHONE
    (describe "An completely empty spec (no contexts/specifications)" `(
      (it "does not break" (do ()
        (puts "\n[!] The following summary is from a regression spec and can be ignored:")
        (~ (system "nush -f ObjectiveBacon -e '(load \"bacon\") ((Bacon sharedInstance) run)'") should be: 0)
      ))
    ))
  )
))


;(describe "Regression specs" `(
  ;(before (do ()
    ;(set @a 42)
  ;))

  ;(describe "from a nested context" `(
    ;(before (do ()
      ;(set @b 42)
    ;))

    ;(describe "from a nested-nested context" `(
      ;(before (do ()
        ;(set @c 42)
      ;))

      ;(it "catches from any depth" (do ()
        ;;(set requirement `(self requirement:"catches from any depth" block:`(
          ;(set values `((1 (-1.23 -2.34)) (2 (-2.34 -3.45))))
          ;(values each:(do (x)
            ;(set a (x array))
            ;(set value (a objectAtIndex:0))
            ;(set valueList (a objectAtIndex:1))
            ;;(puts value)
            ;;(puts valueList)
            ;(((valueList should) be) closeTo:`(-1.23 -2.34)) ; this fails at the second value
          ;))
        ;;) report:nil))
        ;;((((eval requirement) should) not) raise)
      ;))
    ;))
  ;))
;))

; TODO need a cmd line runner!
(unless TARGET_OS_IPHONE
  ((Bacon sharedInstance) run)
)
)
