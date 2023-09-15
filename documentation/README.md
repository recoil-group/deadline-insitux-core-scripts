# Documentation
Overview of the Insitux scripting language and API calls for Deadline.

## Insitux
Insitux is an **s-expression** language, meaning the structure of Insitux is always:
```clj
(function-name argument/s)
```
the first thing in the parenthesis must be an operation, for example, ``+`` is the summing operator:
```clj
(   +              2   2   ) ; => 4
;   ^              ‾‾‾‾‾‾
; operation       arguments
;    =                =
; what to do     do it with what
```
and everything (excluding function declaration) returns a value, meaning:
```clj
 (+   2   (*   3   2)  )
;|    |   |         |  |
;|    |   ^^^^^^^^^^^  |
;(+   2        6       )
;|                     |
;^^^^^^^^^^^^^^^^^^^^^^^
;           8
; => the output will be 8
```

### The basics of Insitux
Insitux is also a **functional** language: we only deal with functions *(for those with some programming knowledge, this is sort of the opposite languages like C++ and Java)*. One declares functions like:
```clj
(function function-name
    (expression)
         .
         .
         .
    (final-expression))
```
the value of the middle expressions is ignored, meaning:
```clj

; note that var returns the value of the last variable
; (var number 2) => 2

(function add-and-store a b
    (var stored-value (+ a b))                ; evaluates to the sum of a and b; the value is ignored
    (print "I just summed " a " and " b "!")  ; evaluates to null (but prints the string); the value is ignored
    stored-value)                             ; evaluates to the stored value of the sum of a and b; the value is returned as this is the last expression

(add-and-store 2 3)
; stored-value = 5
; prints: I just summed 2 and 3!
; returns: 5
stored-value
; 5
```
### Approaches to Insitux
Insitux facilitates the use of the **declarative** style *(for and while loops are permitted, but discouraged, instead: )*; you use functions that apply other functions in different ways, some examples being:
```clj
; map :: function , vector/s, string/s, dictionary/ies -> vector
; map applies the function element by element and returns a vector with the results
(map neg [0 1 2 3 4 5]) ; => [(neg 0) (neg 1) (neg 2) (neg 3) (neg 4) (neg 5)] => [0 -1 -2 -3 -4 -5]
;    ^^^
; negates a number 

(map to-upper "hello") ; => [(to-upper "h") (to-upper "e") (to-upper "l") (to-upper "l") (to-upper "o")] => ["H" "E" "L" "L" "O"]
;    ^^^^^^^
; makes a letter uper case 

(map + [0 1 2] [3 4 5]) ; => [(+ 0 3) (+ 1 4) (+ 2 5)] => [3 5 7]

; filter :: function , vector/s, string/s -> vector, string
; filter takes a predicative (i.e a function that returns true or false) and filters for truthy values in the vector/string
(filter odd? [0 1 2 3 4 5]) ; => [1 3 5]
;       ^^^^
; checks if a number is odd

(filter upper? "HeLlo!") ; => Hl!
;       ^^^^^
; checks if a letter is upper case
```
for the complete list of functions, check https://phunanon.github.io/Insitux

## The Deadline API
An API is basically a collection of functions that allow you to interact with something, in this case, with Deadline.

### Client side
If you do `(dl-print-funcs)` in the Client Console, you'll see that, in the Server Console, a list of functions will appear:

```clj
;;; Misc
(clear) ; clears the console screen

(tick) ; returns tick

(wait n) ; waits n seconds
; :: number -> wait
; (wait 1) => null

;;; Widgets (widget structure will be detailed later)
(create-widget widget-name) ; creates a widget (note that the widget may be invisible, meaning this won't necesseraly make it pop up in your screen)
; :: dictionary (in widget form) -> wdiget creation
; (create-widget { ... }) => null

(patch-widget-by-id id field-to-change) ; changes the field of a widget
; :: string, dictionary -> change in widget
; (patch-widget-by-id "id" { :key ... }) => null

(get-widget-by-id id field) ; gets the value of a field of a widget
; :: string, key -> value
; (get-widget-by-id "id" :key) => value

(clear-all-widgets) ; eliminates all widgets (not just make them invisible)

;;; Events
(on-heartbeat func) ; executes func every tick
; :: function -> event
; (on-heartbeat (print "hi")) => helo
;                                helo
;                                helo
;                                ....
; ! This will crash your game !

(kill-on-heartbeat) ; disconnects every function connected to the event

(send-to-server arg1 arg2 arg3 ...) ; sends arguments to the server
; :: anything, anything, anything ... -> sends to server
; (send-to-server "hello" 0 true {} []) => null
;                                server => "hello" 0 true {} []
; ! Won't actually display anything because you need a on-server event ! (more on that later)

;;; Info
(dl-print-funcs) ; prints functions available

(dl-print-vars) ; prints parameters of the environment
```
