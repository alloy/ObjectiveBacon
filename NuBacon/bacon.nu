; (load "ObjectiveBacon")
; TODO Something like this? (load "ObjectiveBacon:bacon.nu")

(class NSObject
  (- (id) instanceEval:(id)block is
    (set c (send block context))
    (send block evalWithArguments:nil context:c self:self)
  )

  (- (id) stringValue is
    (set description (self description))
    (set className ((self class) name))
    (if (description hasPrefix:"<#{className}")
      (then description)
      (else "#{className}: #{description}")
    )
  )
)

(class BaconContext
  (- (id)evaluateBlock:(id)block is
    (self instanceEval:block)
  )
)

(class BaconShould
  (- (id) match:(id)regexp is
    (self satisfy:"match /#{(regexp pattern)}/" block:(do (string)
      (regexp findInString:string)
    ))
  )

  (- (id)prettyPrint:(id)theObject is
    (send theObject stringValue)
  )

  ; We should not return 0/1/nil etc, but always strict boolean values.
  (- (BOOL)isBlock:(id)block is
    (send block isKindOfClass:NuBlock)
  )

  (- (BOOL)executeAssertionBlock:(id)block is
    ; have to do it this way, otherwise it complains (in certain cases) with:
    ; -[NuSymbol unsignedIntValue]: unrecognized selector sent to instance
    (if (block (self object))
      (then 1)
      (else 0)
    )
  )

  (- (id)executeBlock:(id)block is
    ; when the user uses the `->' macro, the return value is in fact a BaconShould instance instead of a block
    (if (send block isKindOfClass:BaconShould)
      (set shouldInstance block)
      (set block (shouldInstance object))
    )
    (call block)
  )

  (- (id) handleUnknownMessage:(id)message withContext:(id)context is
    (set methodName ((car message) stringValue))
    (set args ((cdr message) array))
    (set description (self descriptionForMissingMethod:methodName arguments:args))
    (set target (self object))

    (if (target respondsToSelector:methodName)
      (then
        ; forward the message as-is
        (self satisfy:description block:(do (object)
          (object sendMessage:message withContext:context)
        ))
      )
      (else
        (set predicate (self predicateVersionOfMissingMethod:methodName arguments:args))
        (if (target respondsToSelector:predicate)
          (then
            ; forward the predicate version of the message with the args
            (self satisfy:description block:(do (object)
              (set symbol ((NuSymbolTable sharedSymbolTable) symbolWithString:predicate))
              (set msg (cons symbol (cdr message)))
              (object sendMessage:msg withContext:context)
            ))
          )
          (else
            (set thirdPersonForm (self thirdPersonVersionOfMissingMethod:methodName arguments:args))
            (if (target respondsToSelector:thirdPersonForm)
              (then
                ; example: respondsToSelector: is matched as respondToSelector:
                (self satisfy:description block:(do (object)
                  (set symbol ((NuSymbolTable sharedSymbolTable) symbolWithString:thirdPersonForm))
                  (set msg (cons symbol (cdr message)))
                  (object sendMessage:msg withContext:context)
                ))
              )
              (else
                ; the object does not respond to any of the messages
                (super handleUnknownMessage:message withContext:context)
              )
            )
          )
        )
      )
    )
  )
)

; main context macros

(set bacon-context nil)

(macro describe (name specifications)
  `(if bacon-context
    (then
      (set parent bacon-context)
      ; create child context and make it the current bacon-context
      (set bacon-context (parent childContextWithName:,name))
      (,specifications each:(do (x) (eval x)))
      ; after evalling the block reset the bacon-context to the previous one
      (set bacon-context parent)
    )
    (else
      ; not running inside a context
      (set bacon-context ((BaconContext alloc) initWithName:,name))
      (,specifications each:(do (x) (eval x)))
      (set bacon-context nil)
    )
  )
)

(macro it (description block)
  `(bacon-context addSpecification:,description withBlock:,block report:t)
)

(macro before (block)
  `(bacon-context addBeforeFilter:,block)
)
(macro after (block)
  `(bacon-context addAfterFilter:,block)
)

; shared contexts

(set $BaconShared (NSMutableDictionary dictionary))

(macro shared (name specifications)
  `($BaconShared setValue:,specifications forKey:,name)
)

(macro behaves_like (name)
  (set shared-context ($BaconShared valueForKey:name))
  (if (shared-context)
    ; each specification is a complete `it' block
    (then (shared-context each:(do (specification) (eval specification))))
    (else (throw "No such context `#{name}'"))
  )
)

; `wait' helper macros

(macro wait (*wait-args)
  (if (eq (*wait-args count) 1)
    (then
      `(((self currentSpecification) postponeBlock:,@*wait-args))
    )
    (else
      (set __seconds (car *wait-args))
      (set __block (cdr *wait-args))
      `(((self currentSpecification) scheduleBlock:,@__block withDelay:,__seconds))
    )
  )
)

(macro wait-max (timeout block)
  `(((self currentSpecification) postponeBlock:,block withTimeout:,timeout))
)

(macro wait-for-change (*wait-args)
  (set __args (*wait-args array))
  (if (eq (*wait-args count) 3)
    (then
      (set __observable (__args objectAtIndex:0))
      (set __key-path (__args objectAtIndex:1))
      (set __block (__args objectAtIndex:2))
      `(((self currentSpecification) postponeBlockUntilChange:,__block ofObject:,__observable withKeyPath:,__key-path))
    )
    (else
      (set __observable (__args objectAtIndex:0))
      (set __key-path (__args objectAtIndex:1))
      (set __timeout (__args objectAtIndex:2))
      (set __block (__args objectAtIndex:3))
      `(((self currentSpecification) postponeBlockUntilChange:,__block ofObject:,__observable withKeyPath:,__key-path timeout:__timeout))
    )
  )
)

; helper macros

(macro sendMessageWithList (object *body)
  (set __body (eval *body))
  (if (not (__body isKindOfClass:NuCell))
    (set __body (list __body))
  )
  `(,object ,@__body)
)

(macro ~ (*objectAndMessages)
  (set __object (eval (car *objectAndMessages)))
  (set __messages (cdr *objectAndMessages))

  (set __messagesWithoutArgs (NSMutableArray array))
  (set __lastMessageWithArgs nil)

  (while (> (__messages count) 0)
    (set __message (car __messages))
    (if (and (__message isKindOfClass:NuSymbol) ((__message stringValue) hasSuffix:":"))
      (then
        ; once we find the first NuSymbol that ends with a colon, i.e. part of a selector with args,
        ; then we take it and the rest as the last message
        (set __lastMessageWithArgs __messages)
        (set __messages `())
      )
      (else
        ; this is a selector without args, so remove it from the messages list and continue
        (__messagesWithoutArgs addObject:__message)
        (set __messages (cdr __messages))
      )
    )
  )

  ; first dispatch all messages without arguments, if there are any
  ((__messagesWithoutArgs list) each:(do (__message)
    (set __object (sendMessageWithList __object __message))
  ))

  ; then either dispatch the last message with arguments, or return the BaconShould instance
  (if (__lastMessageWithArgs)
    (then (sendMessageWithList __object __lastMessageWithArgs))
    (else (__object))
  )
)

(macro -> (blockBody *extraMessages)
  (if (> (*extraMessages count) 0)
    (then
      `(~ (send (do () ,blockBody) should) ,@*extraMessages)
    )
    (else
      `(send (do () ,blockBody) should)
    )
  )
)
