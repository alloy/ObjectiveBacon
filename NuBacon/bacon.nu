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
  (- (id)prettyPrint:(id)object is
    (send object stringValue)
  )

  ; We should not return 0/1/nil etc, but always strict boolean values.
  (- (BOOL)isBlock:(id)block is
    (send block isKindOfClass:NuBlock)
  )

  (- (id)executeAssertionBlock:(id)block is
    (block (self object))
  )

  (- (id)executeBlock:(id)block is
    ; when the user uses the `->' macro, the return value is in fact a BaconShould instance instead of a block
    (if (send block isKindOfClass:BaconShould)
      (set shouldInstance block)
      (set block (shouldInstance object))
    )
    (call block)
  )
)

(macro describe (name specifications)
  `(try
    (set parent bacon-context)
    ; create child context and make it the current bacon-context
    (set bacon-context (parent childContextWithName:,name))
    (,specifications each:(do (x) (eval x)))
    ; after evalling the block reset the bacon-context to the previous one
    (set bacon-context parent)
    (catch (e)
      (if (eq (e reason) "undefined symbol bacon-context while evaluating expression (set parent bacon-context)")
        (then
          ; not running inside a context
          (set bacon-context ((BaconContext alloc) initWithName:,name))
          (,specifications each:(do (x) (eval x)))
        )
        ; another type of exception occured
        (else (throw e))
      )
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
