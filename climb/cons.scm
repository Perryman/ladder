;; * micro: practice consing up various tree patterns, using car and cdr to access values in the consed up tree, drawing box and pointer diagrams, and predicting what the printed representation of a cons expression will look like
;; 2025-02-16
;; Utilizing geiser-eval-last-sexp to insert the
;; result as I go, practicing cons.

;; Make sure I remember the basics from memory.
(cons 'car 'cdr)
(car . cdr)

;; Okay, so this is not a proper list. So let's do
;; just (cons 'car '()) and I expect to see ('car)
(cons 'car '())
(car)

;; So then 'car will need to cons with '(cdr) and
;; not ('cdr) as that would try to eval 'cdr
(cons 'car '(cdr))
(car cdr)

;; Which is the same as (cons 'car (cons 'cdr '()))
(cons 'car (cons 'cdr '()))
(car cdr)

;; Noting that the quotes are removed when chez prints it.

;; Okay, so what are some weird things I can think of?
;; Like how to cons up '(() . ())?
(cons '() '())
(())

;; So if that's a list with the empty list, I need to expand
;; the expression ('() . '()), which is a pair containing
;; nil and nil.

;; *-----*-----*
;; |   / |   / |
;; |  /  |  /  |
;; | /   | /   |
;; *-----*-----*

;; This is what i'm really thinking of.
'(() . ())
(())

;; ah, it's the same as a list of the empty list. And it
;; really was as simple as moving the cons betwen to .

(cons '() (cons '() '()))
(()
 ())

(cons '(()) '(()))
((())
 ())

(cons '((())) '((())))
(((()))
 (()))

(cons '(((()))) '(((()))))
((((())))
 ((())))

;; Hmm, maybe a bit hard to see. What about a and b
(cons '(a) '(d))
((a)
 d)

(cons '((a)) '((d)))
(((a))
 (d))

(cons '(((a))) '(((d))))
((((d)))
 ((d)))

;; Okay, so in the display form: (a d) the car is what it
;; looks like, and the space between implies the pair cdr is
;; wrapped inside ( )

(cons '() '())
(())

'(() . ())
(())

;; Okay, let's set! a list l and try to cons it.

(set! l
      '(
        ((count point) ref)  ; a
        (loc height width)   ; b
        ()                   ; c
        ))
#<void>

l
(((count point) ref)
 (loc height width)
 ())

(cons 'a
      (cons 'b
            (cons 'c
                  '()
                  )))
(a b c)

;; So next expand each a b c and type the expansions in.
(cons '((count point) ref)
      (cons '(loc height width)
            (cons '() ; just a list with the enpty list
                  '()
                  )))
(((count point) ref)
 (loc height width)
 ())

;; Keep expanding
(cons (cons '(count point)
            'ref) ; '((count point) ref)
      (cons (cons 'loc
                  '(height width)); '(loc height width)
            (cons '()
                  '()
                  )))
(((count point) . ref)
 (loc height width)
 ())

;; Okay, we forgot that the cdr gets an implicit ()
;; wrap. try again.
(cons (cons '(count point)
            '(ref)) ; '((count point) ref)
      (cons (cons 'loc
                  '(height width)); '(loc height width)
            (cons '()
                  '()
                  )))
(((count point) ref)
 (loc height width)
 ())

;; That checks out. Continue expanding.
(cons (cons (cons 'count
                  '(point)) ; '(count point)
            (cons 'ref
                  '()))                ; '(ref)
      (cons (cons 'loc
                  (cons 'height
                        '(width))) ; '(height width)
            (cons '()
                  '()
                  )))
(((count point) ref)
 (loc height width)
 ())

;; almost there
(cons (cons (cons 'count
                  (cons 'point
                        '())); '(point)
            (cons 'ref
                  '()))
      (cons (cons 'loc
                  (cons 'height
                        (cons 'width
                              '()))) ; '(width)))
            (cons '()
                  '()
                  )))
(((count point) ref)
 (loc height width)
 ())

l
(((count point) ref)
 (loc height width)
 ())

;; Intersting how the box and pointer diagram alomst shows
;; itself from the pretty-print.
;; Dot notation?
'(count . (point . ()))
(count point)

'((count . (point . ())) . (ref . ()))
((count point) ref)

'(loc . (height . (width . ())))
(loc height width)

'(() . ())
(())

;; Not too bad. Remember proper ' placement. Now piece it
;; together
'(a . (b . (c . ())))
(a b c)

'(a
  .
  (b
   .
   (c
    .
    ())))
(a b c)

;; use this pattern above
'(((count . (point . ())) . (ref . ()))
  .
  ((loc . (height . (width . ())))
   .
   (()
    .
    ())))
(((count point) ref) (loc height width) ())

l
(((count point) ref) (loc height width) ())

;; See what the dotted form looks like when fully
;; line-expanded
'(((count
    .
    (point
     .
     ()))
   .
   (ref
    .
    ()))
  .
  ((loc
    .
    (height
     .
     (width
      .
      ())))
   .
   (()
    .
    ())))
(((count point) ref) (loc height width) ())

;; I like the above form because as the cons . moves right,
;; I see the individual proper lists ending in (). Though
;; the outer lists are a little harder to see.
'(((count .(point .())).(ref .())).((loc .(height .(width .()))).(().())))
(((count point) ref) (loc height width) ())
(((count point) ref)
 (loc height width)
 ())

;; Good enough for now. Future practice/ideas:
;;  - draw these box and pointer diagrams
;;  - write a 1D scheme automata that eats lists in one form,
;;    leaving behind the other form as it goes
;;  - think about where else I might see .
;;  - read scheme cons and . hyperspecs and grammar
