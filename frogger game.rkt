;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname |frogger game|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))

;; Frogger Game
;; author: Moling Guo, Chieh Lee
;; Date: 15 April 2012

(require 2htdp/image)
(require 2htdp/universe)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Data Defination
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; a frog is (make-frog number number string)
(define-struct frog (x y dir))
;; where x and y is number represent the posn
;; and dir is string representing direction

;; a car is (make-car number number string)
(define-struct vehicle (x y dir))
;; where x and y is number represent the posn
;; and dir is string representing direction

;; a set of vehicle is one of:
;; - empty
;; - (cons vehicle set-of-vehicle)
;; where the set-of-vehicle represent all the vehicles
;; appeared crossing the scene

;; a turplank is (make-turplank number number string string)
(define-struct turplank (x y dir))
;; where x and y are numbers represent the posn
;; and dir is string representing direction
;; also all turtle go left, plank go right

;; a set of turplank is one of:
;; - empty
;; - (cons turplank set-of-turplank)
;; where the set-of-turplank represent all the 
;; turtles and planks

;; a world is (make-world frog svehicle sturplank)
(define-struct world (frog vehicle sturplank))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constant Definations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Background
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define roadline (place-image 
                  (rectangle 50 8 "solid" "black") 25 4
                  (place-image 
                   (rectangle 50 8 "solid" "black") 125 4
                   (place-image 
                    (rectangle 50 8 "solid" "black") 225 4
                    (place-image 
                     (rectangle 50 8 "solid" "black") 325 4
                     (place-image 
                      (rectangle 50 8 "solid" "black") 425 4
                      (place-image 
                       (rectangle 50 8 "solid" "black") 525 4
                       (place-image 
                        (rectangle 50 8 "solid" "black") 625 4
                        (place-image 
                         (rectangle 50 8 "solid" "black") 725 4
                         (rectangle 800 8 "solid" "white"))))))))))
(define platform (rectangle 800 50 "solid" "goldenrod"))
(define background (place-image 
                    platform 400 25
                    (place-image 
                     platform 400 721
                     (place-image 
                      platform 400 373
                      (place-image
                       roadline 370 402
                       (place-image
                        roadline 370 460
                        (place-image
                         roadline 370 518
                         (place-image
                          roadline 370 576
                          (place-image
                           roadline 370 634
                           (place-image
                            roadline 370 692
                            (place-image
                             (rectangle 800 373 "solid" "blue")
                             400 186.5   
                            (place-image
                             (rectangle 800 746 "solid" "black")
                             400 373                     
                             (empty-scene 800 746)))))))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Frog image
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define frog-image 
  (overlay/offset 
   (overlay/offset 
    (overlay (circle 4 'solid 'black)
             (circle 5 'solid 'white)) 
    20 0 
    (overlay (circle 4 'solid 'black)
             (circle 5 'solid 'white)))
   0 15
   (overlay/offset 
    (overlay/offset 
     (overlay/offset 
      (polygon (list (make-posn 0 0)
                     (make-posn 0 20)
                     (make-posn 15 20)
                     (make-posn 15 15)
                     (make-posn 5 15)
                     (make-posn 5 0))
               'solid 'green) 35 0 
                              (polygon (list (make-posn 10 0)
                                             (make-posn 10 15)
                                             (make-posn 0 15)
                                             (make-posn 0 20)
                                             (make-posn 15 20)
                                             (make-posn 15 0))
                                       'solid
                                       'green))
     0 32
     (overlay/offset (polygon (list (make-posn 0 10)
                                    (make-posn 0 15)
                                    (make-posn 10 15)
                                    (make-posn 10 5)
                                    (make-posn 15 5)
                                    (make-posn 15 0)
                                    (make-posn 5 0)
                                    (make-posn 5 5))
                              'solid 'green) 
                     35 0 
                     (polygon (list (make-posn 15 10)
                                    (make-posn 15 15)
                                    (make-posn 5 15)
                                    (make-posn 5 5)
                                    (make-posn 0 5)
                                    (make-posn 0 0)
                                    (make-posn 10 0)
                                    (make-posn 10 5))
                              'solid 'green))) 
    0 0 (ellipse 30 40 'solid 'green))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Vehicle image
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define vehicle-image
  (overlay
   (polygon (list (make-posn 10 5)
                  (make-posn 0 15)
                  (make-posn 0 35)
                  (make-posn 10 45)
                  (make-posn 40 45)
                  (make-posn 50 35)
                  (make-posn 50 15)
                  (make-posn 40 5)) 'solid 'cyan)
  (overlay/offset
    (overlay/offset 
     (rectangle 10 6 'solid 'gray)
     22 0
     (rectangle 10 6 'solid 'gray))
    0 40
    (overlay/offset 
     (rectangle 10 6 'solid 'gray)
     22 0
     (rectangle 10 6 'solid 'gray)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Turtle image
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define turtle-image
  (overlay/offset
   (overlay/offset (ellipse 10 12 'solid 'red)
                   0 20
                   (ellipse 30 35 'solid 'red))
   0 5
   (overlay/offset
    (overlay/offset
     (polygon (list (make-posn 6 0)
                    (make-posn 0 5)
                    (make-posn 3 10)
                    (make-posn 6 5)
                    (make-posn 9 10)
                    (make-posn 12 5)) 'solid 'red)
     38 0
     (polygon (list (make-posn 6 0)
                    (make-posn 0 5)
                    (make-posn 3 10)
                    (make-posn 6 5)
                    (make-posn 9 10)
                    (make-posn 12 5)) 'solid 'red))
    0 28
    (overlay/offset
     (polygon (list (make-posn 8 0)
                    (make-posn 0 6)
                    (make-posn 5 12)
                    (make-posn 8 9)
                    (make-posn 5 6)
                    (make-posn 12 3)) 'solid 'red)
     38 0
     (polygon (list (make-posn 4 0)
                    (make-posn 12 6)
                    (make-posn 7 12)
                    (make-posn 4 9)
                    (make-posn 7 6)
                    (make-posn 0 3)) 'solid 'red)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Plank image
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define plank-image (overlay/offset 
                     (overlay/offset 
                      (overlay 
                       (ellipse 1 10 'outline 'brown)
                       (overlay 
                        (ellipse 5 30 'outline 'brown)
                        (overlay
                         (ellipse 10 40 'outline 'brown)
                         (ellipse 15 50 'solid 'peru))))
                      50 0
                      (ellipse 15 50 'solid 'brown))
                     0 0
                     (square 50 'solid 'brown)))
(define platform-end 25)
(define river5 83)
(define river4 141)
(define river3 199)
(define river2 257)
(define river1 315)
(define platform-mid 373)
(define road5 431)
(define road4 489)
(define road3 547)
(define road2 605)
(define road1 663)
(define platform-start 721)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; example data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define Vset1 
  (list (make-vehicle 250 road3 "right") 
        (make-vehicle 400 road3 "right") 
        (make-vehicle 250 road2 "left")))

(define TPset1
  (list (make-turplank 100 river1 "left")
        (make-turplank 250 river2 "right")
        (make-turplank 400 river3 "left")))

(define world1
  (make-world (make-frog 250 platform-start "stop")
              Vset1 TPset1))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Drawing Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; draw-world : world -> image
;; draw frog, vehicles, turtles and planks in the given
;; world

(define (draw-world w)
  (local
    [(define (draw-frog frog1 scn)
       (place-image
        frog-image
        (frog-x frog1)
        (frog-y frog1)
        scn))
     (define (draw-vehicle vset1 scn)
       (foldr (lambda (x y) (place-image 
                             vehicle-image
                             (vehicle-x x)
                             (vehicle-y x)
                             y))
              scn
              vset1))
     (define (draw-turplank TPset1 scn)
       (foldr (lambda (x y) (place-image 
                             (cond 
                               [(string=? (turplank-dir x) "left")
                                turtle-image]
                               [else plank-image])
                             (turplank-x x)
                             (turplank-y x)
                             y))
              scn
              TPset1))]
    (draw-frog (world-frog w)
               (draw-vehicle (world-vehicle w)
                             (draw-turplank (world-sturplank w) background)))))

;; tests

(check-expect 
 (draw-world 
  (make-world
   (make-frog 250 platform-start "stop")
   empty empty))
 (place-image frog-image
              250 platform-start
              background))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Moving Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; move-object : Xset -> Xset
;; move set of objects via using above
;; two helper functions

(define (move-object Oset1)
  (local
    [(define (move-object-d v f)
       (cond [(vehicle? v)
              (make-vehicle
               (f (vehicle-x v) 1)
               (vehicle-y v)
               (vehicle-dir v))]
             [(turplank? v)
              (make-turplank
               (f (turplank-x v) 1)
               (turplank-y v)
               (turplank-dir v))]))]
    (cond
      [(empty? Oset1) empty]
      [(vehicle? (first Oset1)) 
       (map (lambda (x) (cond
                          [(string=? "left" (vehicle-dir x))
                           (move-object-d x -)]
                          [(string=? "right" (vehicle-dir x))
                           (move-object-d x +)]
                          [else move-object]))
            Oset1)]
       [(turplank? (first Oset1))
        (map (lambda (x) (cond
                          [(string=? "left" (turplank-dir x))
                           (move-object-d x -)]
                          [(string=? "right" (turplank-dir x))
                           (move-object-d x +)]
                          [else move-object]))
            Oset1)])))

;; tests

(check-expect
 (move-object empty)
 empty)

(check-expect 
 (move-object Vset1)
 (list (make-vehicle 251 road3 "right")
       (make-vehicle 401 road3 "right")
       (make-vehicle 249 road2 "left")))

(check-expect 
 (move-object TPset1)
  (list (make-turplank 99 river1 "left")
        (make-turplank 251 river2 "right")
        (make-turplank 399 river3 "left")))




;; move-frog : frog -> frog
;; move frog according to it's direction
;; if it's "up" then subtract 58 pixel
;; if it's "down" then add 58 pixel
;; (58 is the range between two roads)
;; "right" "left" move frog by 20 pixel
;; dir return "stop" after every change



(define (move-frog f)
  (cond
    [(string=? "up" (frog-dir f))
     (cond
       [(= (frog-y f) platform-end) f]
       [else (make-frog (frog-x f) (- (frog-y f) 58) "stop")])]
    [(string=? "down" (frog-dir f))
     (cond
       [(= (frog-y f) platform-start) f]
       [else (make-frog (frog-x f) (+ (frog-y f) 58) "stop")])]
    [(string=? "right" (frog-dir f))
     (cond
       [(>= (frog-x f) 775) f]
       [else (make-frog (+ 20 (frog-x f))(frog-y f) "stop")])]
    [(string=? "left" (frog-dir f))
     (cond
       [(<= (frog-x f) 25) f]
       [else (make-frog (- (frog-x f) 20) (frog-y f) "stop")])]
    [else 
     (cond
       [(or (= (frog-y f) river1)    ;; when frog-y = any of river, frog keeps
            (= (frog-y f) river4))   ;; adding or subtracting 1 so frog will 
        (make-frog (- (frog-x f) 1)  ;; move along with turtle or plank
                   (frog-y f)
                   "stop")]
       [(or (= (frog-y f) river2)
            (= (frog-y f) river3)
            (= (frog-y f) river5))
        (make-frog (+ (frog-x f) 1)
                   (frog-y f)
                   "stop")]
       [else f])]))


;; tests

(check-expect 
 (move-frog (make-frog 225 platform-start "up"))
 (make-frog 225 road1 "stop"))

(check-expect 
 (move-frog (make-frog 225 road2 "down"))
 (make-frog 225 road1 "stop"))

(check-expect
 (move-frog (make-frog 225 road1 "left"))
 (make-frog 205 road1 "stop"))

(check-expect
 (move-frog (make-frog 225 road1 "right"))
 (make-frog 245 road1 "stop"))

(check-expect 
 (move-frog (make-frog 225 road1 "stop"))
 (make-frog 225 road1 "stop"))

(check-expect
 (move-frog (make-frog 225 river1 "stop"))
 (make-frog 224 river1 "stop"))

(check-expect
 (move-frog (make-frog 225 river3 "stop"))
 (make-frog 226 river3 "stop"))



;; add-new-object? : Xset -> boolean
;; determine whether object is off-screen
;; and return boolean true when 
;; boolean is off-screen and vice versa

;; template

#;(define (ano? Oset1)
    (cond
      [(empty? Oset1) ...]
      [else (... (first Oset1) ...)
            (ano? (rest Oset1))]))


(define (ano? Oset1)
  (cond
    [(empty? Oset1) false]
    [(vehicle? (first Oset1))
     (ormap (lambda (x) (or (and (string=? "left" (vehicle-dir x))
                                 (= 0 (vehicle-x x)))
                            (and (string=? "right" (vehicle-dir x))
                                 (= 800 (vehicle-x x)))))
            Oset1)]
    [(turplank? (first Oset1))
     (ormap (lambda (x) (or (and (string=? "left" (turplank-dir x))
                                 (= 0 (turplank-x x)))
                            (and (string=? "right" (turplank-dir x))
                                 (= 800 (turplank-x x)))))
            Oset1)]))
  

;; tests

(check-expect 
 (ano? (list 
        (make-vehicle 400 road1 "left")
        (make-vehicle 200 road1 "left")
        (make-vehicle 800 road2 "right")))
 true)

(check-expect 
 (ano? (list 
        (make-vehicle 401 road1 "left")
        (make-vehicle 200 road1 "left")
        (make-vehicle 100 road2 "right")))
 false)

(check-expect 
 (ano? (list 
        (make-vehicle 0 road1 "left")
        (make-vehicle 200 road1 "left")
        (make-vehicle 102 road2 "right")))
 true)

(check-expect 
 (ano? (list 
        (make-turplank 400 road1 "left")
        (make-turplank 200 road1 "left")
        (make-turplank 800 road2 "right")))
 true)

(check-expect 
 (ano? (list 
        (make-turplank 401 road1 "left")
        (make-turplank 200 road1 "left")
        (make-turplank 100 road2 "right")))
 false)

(check-expect 
 (ano? (list 
        (make-turplank 0 road1 "left")
        (make-turplank 200 road1 "left")
        (make-turplank 102 road2 "right")))
 true)


;; add-new-vehicle : vehicle -> vehicle
;; add new vehicle if any vehicle in the 
;; given vset is off-screen,
;; if left dir vehicle is off-screen, add
;; new vehicle on posn x=800
;; x=0 when vehicle dir is right


(define (anv-list Vset1)
  (cond
    [(empty? Vset1) empty]
    [(and (= 0 (vehicle-x (first Vset1)))
          (string=? "left" (vehicle-dir (first Vset1))))
     (cons (make-vehicle 800 (vehicle-y (first Vset1)) "left")
           (anv-list (rest Vset1)))]
    [(and (= 800 (vehicle-x (first Vset1)))
          (string=? "right" (vehicle-dir (first Vset1))))
     (cons (make-vehicle 0 (vehicle-y (first Vset1)) "right")
           (anv-list (rest Vset1)))]
    [else (cons (first Vset1) (anv-list (rest Vset1)))]))

;; tests

(check-expect
(anv-list (list (make-vehicle 0 83 "left")
                (make-vehicle 485 83 "right")
                (make-vehicle 249 141 "left")))
(list (make-vehicle 800 83 "left") 
      (make-vehicle 485 83 "right") 
      (make-vehicle 249 141 "left")))

(check-expect
(anv-list (list (make-vehicle 800 road2 "right")
                (make-vehicle 431 road1 "left")
                (make-vehicle 201 road2 "right")))
(list (make-vehicle 0 road2 "right") 
      (make-vehicle 431 road1 "left") 
      (make-vehicle 201 road2 "right")))

(check-expect
(anv-list (list (make-vehicle 800 road2 "right")
                (make-vehicle 0 road1 "left")
                (make-vehicle 195 road3 "left")))
(list (make-vehicle 0 road2 "right") 
      (make-vehicle 800 road1 "left") 
      (make-vehicle 195 road3 "left")))


;; add-new-turplank : turplank -> turplank
;; add new turplank if any turplank in the 
;; given TPset is off-screen,
;; if left dir turplank is off-screen, add
;; new turplank on posn x=800
;; x=0 when turplank dir is right

(define (antp-list TPset1)
  (cond
    [(empty? TPset1) empty]
    [(and (= 0 (turplank-x (first TPset1)))
          (string=? "left" (turplank-dir (first TPset1))))
     (cons (make-turplank 800 (turplank-y (first TPset1)) "left")
           (antp-list (rest TPset1)))]
    [(and (= 800 (turplank-x (first TPset1)))
          (string=? "right" (turplank-dir (first TPset1))))
     (cons (make-turplank 0 (turplank-y (first TPset1)) "right")
           (antp-list (rest TPset1)))]
    [else (cons (first TPset1) (antp-list (rest TPset1)))]))

;; tests

(check-expect
(antp-list (list (make-turplank 0 83 "left")
                (make-turplank 485 83 "right")
                (make-turplank 249 141 "left")))
(list (make-turplank 800 83 "left") 
      (make-turplank 485 83 "right") 
      (make-turplank 249 141 "left")))

(check-expect
(antp-list (list (make-turplank 800 river2 "right")
                (make-turplank 431 river1 "left")
                (make-turplank 201 river2 "right")))
(list (make-turplank 0 river2 "right") 
      (make-turplank 431 river1 "left") 
      (make-turplank 201 river2 "right")))

(check-expect
(antp-list (list (make-turplank 800 river2 "right")
                (make-turplank 0 river1 "left")
                (make-turplank 195 river4 "left")))
(list (make-turplank 0 river2 "right") 
      (make-turplank 800 river1 "left") 
      (make-turplank 195 river4 "left")))

;; world-tick : world -> world
;; update the world in each tick

(define (world-tick w)
  (make-world
   (cond [(ano? (world-sturplank w))
                (make-frog (frog-x (world-frog w))
                           (frog-y (world-frog w))
                           "stop")]
         [else (move-frog (world-frog w))])
   (cond
     [(ano? (world-vehicle w))
      (anv-list (world-vehicle w))]
     [else (move-object (world-vehicle w))])
   (cond
     [(ano? (world-sturplank w))
      (antp-list (world-sturplank w))]
     [else (move-object (world-sturplank w))])))

(check-expect
 (world-tick
  (make-world
   (make-frog 250 platform-start "up")
   (list
    (make-vehicle 0 road1 "left")
    (make-vehicle 100 road2 "right")
    (make-vehicle 250 road3 "left"))
   (list
    (make-turplank 0 river1 "left")
    (make-turplank 100 river2 "right")
    (make-turplank 250 river3 "right"))))
 (make-world (make-frog 250 platform-start "stop") 
             (list (make-vehicle 800 road1 "left") 
                   (make-vehicle 100 road2 "right") 
                   (make-vehicle 250 road3 "left"))
             (list (make-turplank 800 river1 "left")
                   (make-turplank 100 river2 "right")
                   (make-turplank 250 river3 "right"))))

(check-expect
 (world-tick
  (make-world 
   (make-frog 250 257 "up") 
   (list (make-vehicle 0 road2 "right") 
         (make-vehicle 250 road3 "left"))
   (list (make-turplank 0 river1 "left")
         (make-turplank 250 river3 "right"))))
 (make-world 
  (make-frog 250 257 "stop") 
  (list 
   (make-vehicle 1 road2 "right") 
   (make-vehicle 249 road3 "left"))
  (list
   (make-turplank 800 river1 "left")
   (make-turplank 250 river3 "right"))))


(check-expect
(world-tick
 (make-world
  (make-frog 250 platform-start "up")
  (list (make-vehicle 101 road1 "left")
        (make-vehicle 1 road1 "left")
        (make-vehicle 201 road1 "left"))
  (list (make-turplank 101 river1 "left")
        (make-turplank 1 river1 "left")
        (make-turplank 201 river1 "left"))))
(make-world 
 (make-frog 250 road1 "stop") 
 (list 
  (make-vehicle 100 road1 "left") 
  (make-vehicle 0 road1 "left") 
  (make-vehicle 200 road1 "left"))
 (list
  (make-turplank 100 river1 "left")
  (make-turplank 0 river1 "left")
  (make-turplank 200 river1 "left"))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gameover Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; stop? : World -> boolean
;; consume world and determine whether
;; the game is end

(define (stop? w)
  (local
    [(define (in-range? n1 n2)
  (or 
   (= n1 n2) 
   (and (> n1 n2)
        (< (- n1 n2) 50))
   (and (> n2 n1)
        (< (- n2 n1) 50))))
     (define (hit? f v)
  (and (= (frog-y f)
          (vehicle-y v))
       (in-range? (frog-x f)
                  (vehicle-x v))))
  
       (define (pick-turplank TPset n)
  (cond [(empty? TPset) empty]
        [else (cond 
                [(= (turplank-y (first TPset)) n)
                 (cons (first TPset)
                       (pick-turplank (rest TPset) n))]
                [else (pick-turplank (rest TPset) n)])]))
       
     (define (in-river? f TPset)
  (cond
    [(empty? TPset) true]
    [(or (= (frog-y f) river1)
         (= (frog-y f) river2)
         (= (frog-y f) river3)
         (= (frog-y f) river4)
         (= (frog-y f) river5))
     (and (not (in-range? (frog-x f)
                          (turplank-x 
                           (first 
                            (pick-turplank TPset
                                           (frog-y f))))))
          (in-river? f 
                     (rest 
                      (pick-turplank TPset
                                     (frog-y f)))))]
    [else false]))]
  (cond
    [(empty? (world-vehicle w)) false]
    [(or (= (frog-y (world-frog w)) road1)
         (= (frog-y (world-frog w)) road2)
         (= (frog-y (world-frog w)) road3)
         (= (frog-y (world-frog w)) road4)
         (= (frog-y (world-frog w)) road5))
     (cond
       [(hit? (world-frog w) 
              (first (world-vehicle w)))
        true]
       [else (stop? (make-world
                     (world-frog w)
                     (rest (world-vehicle w))
                     (world-sturplank w)))])]
    [(in-river? (world-frog w)
                (world-sturplank w))
     true]
    [(or (= (frog-x (world-frog w)) 0)
         (= (frog-x (world-frog w)) 800)
         (= (frog-y (world-frog w)) platform-end))
     true]
    [else false])))

;; tests

(check-expect (stop? world1) false)

(check-expect 
 (stop?
  (make-world (make-frog 250 road3 "down")
              Vset1 TPset1))
 true)

(check-expect
 (stop?
  (make-world (make-frog 0 373 "down")
              Vset1 TPset1))
 true)

(check-expect
 (stop?
  (make-world (make-frog 800 373 "down")
              Vset1 TPset1))
 true)

(check-expect
 (stop?
  (make-world (make-frog 400 platform-end "down")
              Vset1 TPset1))
 true)
 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BIG-BANG HANDLERS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; key-handler
;; Checks for key events--
;; if the key is one of the comand, change the direction
;; accordingly and remake the world

(define (key-handler w k)
  (cond
    [(or (string=? k "up")
         (string=? k "down")
         (string=? k "left")
         (string=? k "right"))
     (make-world
      (make-frog (frog-x (world-frog w))
                 (frog-y (world-frog w))
                 k)
      (world-vehicle w)
      (world-sturplank w))]
    [else w]))

;; tests

(check-expect
 (key-handler world1 "left")
 (make-world 
  (make-frog 250 platform-start "left") 
  (list (make-vehicle 250 road3 "right") 
        (make-vehicle 400 road3 "right") 
        (make-vehicle 250 road2 "left"))
  (list (make-turplank 100 river1 "left")
        (make-turplank 250 river2 "right")
        (make-turplank 400 river3 "left"))))


;; initial world

(define world0
  (make-world
   (make-frog 400 platform-start "stop")
   (list (make-vehicle 800 road1 "left")
         (make-vehicle 600 road1 "left")
         (make-vehicle 400 road1 "left")
         (make-vehicle 200 road1 "left")
         (make-vehicle 0 road1 "left")
         
         (make-vehicle 30 road2 "right")
         (make-vehicle 230 road2 "right")
         (make-vehicle 430 road2 "right")
         (make-vehicle 630 road2 "right")
         
         (make-vehicle 50 road3 "left")
         (make-vehicle 250 road3 "left")
         (make-vehicle 450 road3 "left")
         (make-vehicle 650 road3 "left")
         
         (make-vehicle 60 road4 "right")
         (make-vehicle 260 road4 "right")
         (make-vehicle 460 road4 "right")
         (make-vehicle 660 road4 "right")
         
         (make-vehicle 80 road5 "left")
         (make-vehicle 280 road5 "left")
         (make-vehicle 480 road5 "left")
         (make-vehicle 680 road5 "left"))
   
   (list (make-turplank 25 river1 "left")
         (make-turplank 75 river1 "left")
         (make-turplank 125 river1 "left")
         (make-turplank 275 river1 "left")
         (make-turplank 325 river1 "left")
         (make-turplank 375 river1 "left")
         (make-turplank 525 river1 "left")
         (make-turplank 575 river1 "left")
         (make-turplank 625 river1 "left")
         
         (make-turplank 40 river2 "right")
         (make-turplank 90 river2 "right")
         (make-turplank 140 river2 "right")
         (make-turplank 340 river2 "right")
         (make-turplank 390 river2 "right")
         (make-turplank 440 river2 "right")
         (make-turplank 640 river2 "right")
         (make-turplank 690 river2 "right")
         (make-turplank 740 river2 "right")
         
         (make-turplank 10 river3 "right")
         (make-turplank 60 river3 "right")
         (make-turplank 110 river3 "right")
         (make-turplank 160 river3 "right")
         (make-turplank 210 river3 "right")
         (make-turplank 260 river3 "right")
         (make-turplank 410 river3 "right")
         (make-turplank 460 river3 "right")
         (make-turplank 510 river3 "right")
         (make-turplank 560 river3 "right")
         (make-turplank 610 river3 "right")
         (make-turplank 660 river3 "right")
         
         (make-turplank 30 river4 "left")
         (make-turplank 80 river4 "left")
         (make-turplank 230 river4 "left")
         (make-turplank 280 river4 "left")
         (make-turplank 430 river4 "left")
         (make-turplank 480 river4 "left")
         (make-turplank 630 river4 "left")
         (make-turplank 680 river4 "left")

         (make-turplank 30 river5 "right")
         (make-turplank 80 river5 "right")
         (make-turplank 130 river5 "right")
         (make-turplank 180 river5 "right")
         (make-turplank 300 river5 "right")
         (make-turplank 350 river5 "right")
         (make-turplank 400 river5 "right")
         (make-turplank 450 river5 "right") 
         (make-turplank 580 river5 "right")
         (make-turplank 630 river5 "right")
         (make-turplank 680 river5 "right")
         (make-turplank 730 river5 "right"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Stop scene
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (STOP w)
  (cond [(= (frog-y (world-frog w)) platform-end)
         (place-image 
          (text "CONGRATULATIONS!" 70 "white") 
          400 373 (draw-world w))]
        [else 
         (place-image 
          (text "GAME OVER" 70 "white") 
          400 373 (draw-world w))]))

;; final test
(check-expect (STOP (make-world (make-frog 250 platform-end "down")
                                empty empty))
              (place-image (text "CONGRATULATIONS!" 70 "white")
                           400 373 
                           (place-image frog-image
                                        250 platform-end
                                        background)))
(check-expect 
 (STOP (make-world (make-frog 250 100 "down")
                   empty empty))
 (place-image (text "GAME OVER" 70 "white") 400 373
              (place-image frog-image
                           250 100
                           background)))


(big-bang world0
          (to-draw draw-world)
          (on-tick world-tick 0.002)
          (on-key key-handler)
          (stop-when stop? STOP))
