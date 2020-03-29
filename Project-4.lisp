;(defvar *current_board* (make-array '(5 5)))
(defvar *current_board* '((nil nil nil nil nil)
                         (nil nil nil nil nil)
                         (nil nil nil nil nil)
                         (nil nil nil nil nil)
                         (nil nil nil nil nil)))
(defvar *diagonal-coordinates* '(((0 0) (1 1) (2 2) (3 3) (4 4))
                                 ((0 4) (1 3) (2 2) (3 1) (4 0))
                                 ((1 0) (2 1) (3 2) (4 3))
                                 ((3 0) (2 1) (1 2) (0 3))
                                 ((0 1) (1 2) (2 3) (3 4))
                                 ((4 1) (3 2) (2 3) (1 4))
                                ))
(defvar *turn* 0)
(defvar *p1_char* "X")
(defvar *p2_char* "O")

(defun print-board()
    (dotimes (i 5)
        (print (nth i *current_board*))
    )
)
(defun get-next-row-from-col (col)
    (if (or (> col 4) (< col 0) (not (integerp col)))
        (return-from get-next-row-from-col -1)
    )
    (dotimes (i 5)
        (if (nth col (nth i *current_board*))
            (return-from get-next-row-from-col (- i 1))
        )

    )
    (return-from get-next-row-from-col 4)
)

(defun get-next-row-from-col-hypo (col game-board)
    (if (or (> col 4) (< col 0) (not (integerp col)))
        (return-from get-next-row-from-col-hypo -1)
    )
    (dotimes (i 5)
        (if (nth col (nth i game-board))
            (return-from get-next-row-from-col-hypo (- i 1))
        )

    )
    (return-from get-next-row-from-col-hypo 4)
)

; Flip the turn and return the character used BEFORE turn is flipped
(defun flip-turn ()
    (if (= *turn* 0)
        (progn
        (setf *turn* 1)
        *p1_char*
        )
        (progn
        (setf *turn* 0)
        *p2_char*
        )

    )
)

(defun get-turn-char (turn)
    (if (= turn 0)
        (progn
        *p1_char*
        )
        (progn
        *p2_char*
        )
    )
)

(defun make-move (col)
    (if (>= (get-next-row-from-col col) 0)
        (setf (nth col (nth (get-next-row-from-col col) *current_board*)) (flip-turn))
        (progn
        (print "Move invalid.")
        nil
        )
    )
)

(defun make-move-hypothetical (col game-board turn)
    (setf new-board (copy-tree game-board))
    (if (>= (get-next-row-from-col-hypo col new-board) 0)
        (setf (nth col (nth (get-next-row-from-col-hypo col new-board) new-board)) (get-turn-char turn))
        (progn
        nil
        )
    )
    (return-from make-move-hypothetical new-board)
)
;check if connected four horizontally in previous turn
(defun check-win-horizontal()
    (if (= *turn* 0)
        (setf char-to-check *p2_char*)
        (setf char-to-check *p1_char*)
    )
    (dotimes (i 5)
        (setf counter 0)
        (setf row-check (nth i *current_board*))
        (dotimes (j 5)
            (if (and (nth j row-check) (equalp (nth j row-check) char-to-check))
                (progn
                (setf counter (+ counter 1))
                (if (= counter 4)
                    (return-from check-win-horizontal t)
                )
                )
                (if (not (null (nth j row-check)))
                    (setf counter 0)
                )
            )
        )
    )
)
(defun check-win-vertical()
    (if (= *turn* 0)
        (setf char-to-check *p2_char*)
        (setf char-to-check *p1_char*)
    )
    (dotimes (i 5)
        (setf counter 0)
        (dotimes (j 5)
            (if (and (nth i (nth j *current_board*)) (equalp (nth i (nth j *current_board*)) char-to-check))
                (progn
                (setf counter (+ counter 1))
                (if (= counter 4)
                    (return-from check-win-vertical t)
                )
                )
                (if (not (null (nth i (nth j *current_board*))))
                    (setf counter 0)
                )

            )
        )
    )
)


;Check win on major diagonals
(defun check-win-major-diagonals ()
    (if (= *turn* 0)
        (setf char-to-check *p2_char*)
        (setf char-to-check *p1_char*)
    )
    (if (and (equalp (nth 2 (nth 2 *current_board*)) char-to-check) (equalp (nth 1 (nth 1 *current_board*)) char-to-check) (equalp (nth 3 (nth 3 *current_board*)) char-to-check))
        (if (or (equalp (nth 0 (nth 0 *current_board*)) char-to-check) (equalp (nth 4 (nth 4 *current_board*)) char-to-check))
            (return-from check-win-major-diagonals t)
        )
    )
    (if (and (equalp (nth 2 (nth 2 *current_board*)) char-to-check) (equalp (nth 3 (nth 1 *current_board*)) char-to-check) (equalp (nth 1 (nth 3 *current_board*)) char-to-check))
        (if (or (equalp (nth 4 (nth 0 *current_board*)) char-to-check) (equalp (nth 0 (nth 4 *current_board*)) char-to-check))
            (return-from check-win-major-diagonals t)
        )
    )

)

;Check win on minor diagonals
(defun check-win-minor-diagonals ()
    (if (= *turn* 0)
        (setf char-to-check *p2_char*)
        (setf char-to-check *p1_char*)
    )
    (if (and (equalp (nth 1 (nth 0 *current_board*)) char-to-check) (equalp (nth 2 (nth 1 *current_board*)) char-to-check) (equalp (nth 3 (nth 2 *current_board*)) char-to-check) (equalp (nth 4 (nth 3 *current_board*)) char-to-check))
        (return-from check-win-minor-diagonals t)
    )
    (if (and (equalp (nth 3 (nth 0 *current_board*)) char-to-check) (equalp (nth 2 (nth 1 *current_board*)) char-to-check) (equalp (nth 1 (nth 2 *current_board*)) char-to-check) (equalp (nth 0 (nth 3 *current_board*)) char-to-check))
        (return-from check-win-minor-diagonals t)
    )

    (if (and (equalp (nth 0 (nth 1 *current_board*)) char-to-check) (equalp (nth 1 (nth 2 *current_board*)) char-to-check) (equalp (nth 2 (nth 3 *current_board*)) char-to-check) (equalp (nth 3 (nth 4 *current_board*)) char-to-check))
        (return-from check-win-minor-diagonals t)
    )

    (if (and (equalp (nth 4 (nth 1 *current_board*)) char-to-check) (equalp (nth 3 (nth 2 *current_board*)) char-to-check) (equalp (nth 2 (nth 3 *current_board*)) char-to-check) (equalp (nth 1 (nth 4 *current_board*)) char-to-check))
        (return-from check-win-minor-diagonals t)
    )

)
(defun check-win-diagonal()
    (or (check-win-major-diagonals) (check-win-minor-diagonals))
)
; Check win for previous turn
(defun check-win ()
    (or (check-win-horizontal) (check-win-vertical) (check-win-diagonal))
)

;HEURISTIC FUNCTION: How many in a row you have

;Minimax search:
;Simulate every possible move down to 4 ply, put it in a tree
;Evaluate lower tree using heuristic function, min/max depending on move
; min = ai (p2char, O) max = player (p1char, X)
;Etc
;PROBLEM WITH HEURISTIC FUNCTION: L-R Bias
;Plus does not take into account instant win conditions, instead favoring long-range goal all the time

(defun heuristic-function-horizontal (game-board)
    ;check how close we are to a connect 4 horizontally
    ;count nils AND whatever character we have
    (setf total-score 0)
    (dotimes (i 5)
        (setf counter 0)
        (setf counter2 0)
        (setf row-check (nth i game-board))
        (dotimes (j 5)
            (if (equalp (nth j row-check) *p1_char*)
                (progn
                (setf counter (+ counter 1))
                )
                (if (equalp (nth j row-check) *p2_char*)
                    (progn
                    (if (>= (+ counter counter2) 4)
                        (if (>= counter 3)
                            (setf total-score (+ total-score 50))
                            (setf total-score (+ total-score counter))
                         )
                    )
                    (setf counter 0)
                    (setf counter2 0)
                    )
                    (if (null (nth j row-check))
                        (setf counter2 (+ counter2 1))
                    )
                )
            )
        )
        (if (>= (+ counter2 counter) 4)
            (if (>= counter 3)
                (setf total-score (+ total-score 50))
                (setf total-score (+ total-score counter))
             )
        )
    )
    (dotimes (k 5)
        (setf counter 0)
        (setf counter2 0)
        (setf row-check (nth k game-board))
        (dotimes (l 5)
            (if (equalp (nth l row-check) *p2_char*)
                (progn
                (setf counter (+ counter 1))
                )
                (if (equalp (nth l row-check) *p1_char*)
                    (progn
                    (if (>= (+ counter counter2) 4)
                        (if (>= counter 3)
                            (setf total-score (- total-score 50))
                            (setf total-score (- total-score counter))
                         )
                    )
                    (setf counter 0)
                    (setf counter2 0)
                    )
                    (if (null (nth l row-check))
                        (setf counter2 (+ counter2 1))
                    )
                )
            )
        )
        (if (>= (+ counter2 counter) 4)
            (if (>= counter 3)
                (setf total-score (- total-score 50))
                (setf total-score (- total-score counter))
             )
        )
    )

    (return-from heuristic-function-horizontal total-score)
)

(defun heuristic-function-vertical (game-board)
    ;check how close we are to a connect 4 vertically
    ;count nils AND whatever character we have
    (setf total-score 0)
    (dotimes (i 5)
        (setf counter 0)
        (setf counter2 0)
        (dotimes (j 5)
            (if (equalp (nth i (nth j game-board)) *p1_char*)
                (progn
                (setf counter (+ counter 1))
                )
                (if (equalp (nth i (nth j game-board)) *p2_char*)
                    (progn
                    (if (>= (+ counter counter2) 4)
                        (if (>= counter 3)
                            (setf total-score (+ total-score 50))
                            (setf total-score (+ total-score counter))
                         )
                    )
                    (setf counter 0)
                    (setf counter2 0)
                    )
                    (if (null (nth j game-board))
                        (setf counter2 (+ counter2 1))
                    )
                )
            )
        )
        (if (>= (+ counter counter2) 4)
            (if (>= counter 3)
                (setf total-score (+ total-score 50))
                (setf total-score (+ total-score counter))
             )
        )
    )
    (dotimes (k 5)
        (setf counter 0)
        (setf counter2 0)
        (dotimes (l 5)
            (if (equalp (nth k (nth l game-board)) *p2_char*)
                (progn
                (setf counter (+ counter 1))
                )
                (if (equalp (nth k (nth l game-board)) *p1_char*)
                    (progn
                    (if (>= (+ counter counter2) 4)
                        (if (>= counter 3)
                            (setf total-score (- total-score 50))
                            (setf total-score (- total-score counter))
                         )
                    )
                    (setf counter 0)
                    (setf counter2 0)
                    )
                    (if (null (nth k (nth l game-board)))
                        (setf counter2 (+ counter2 1))
                    )
                )
            )
        )
        (if (>= (+ counter2 counter) 4)
            (if (>= counter 3)
                (setf total-score (- total-score 50))
                (setf total-score (- total-score counter))
             )
        )
    )

    (return-from heuristic-function-vertical total-score)
)

(defun heuristic-function-diagonal (game-board)
    (setf total-score 0)
    (loop for diagonal in *diagonal-coordinates* do
          (setf counter 0)
          (setf counter2 0)
          (loop for coordinate in diagonal do

            (if (equalp (nth (nth 0 coordinate) (nth (nth 1 coordinate) game-board)) *p1_char*)
                (setf counter (+ counter 1))
                (if (equalp (nth (nth 0 coordinate) (nth (nth 1 coordinate) game-board)) *p2_char*)
                    (progn
                    (if (>= (+ counter counter2) 4)
                        (if (>= counter 4) ;Up the weight on the counter because harder to make a diagonal move
                            (setf total-score (+ total-score 50))
                            (setf total-score (+ total-score counter))
                         )
                    )
                    (setf counter 0)
                    (setf counter2 0)
                    )
                    (if (null (nth (nth 0 coordinate) (nth (nth 1 coordinate) game-board)))
                        (setf counter2 (+ counter2 1))
                    )
                )
            )
          )
        (if (>= (+ counter counter2) 4)
            (if (>= counter 4) ;Up the weight on the counter because harder to make a diagonal move
                (setf total-score (+ total-score 50))
                (setf total-score (+ total-score counter))
             )
        )
    )
    (loop for diagonal in *diagonal-coordinates* do
          (setf counter 0)
          (setf counter2 0)
          (loop for coordinate in diagonal do

            (if (equalp (nth (nth 0 coordinate) (nth (nth 1 coordinate) game-board)) *p2_char*)
                (setf counter (+ counter 1))
                (if (equalp (nth (nth 0 coordinate) (nth (nth 1 coordinate) game-board)) *p1_char*)
                    (progn
                    (if (>= (+ counter counter2) 4)
                        (if (>= counter 4) ;Up the weight on the counter because harder to make a diagonal move
                            (setf total-score (- total-score 50))
                            (setf total-score (- total-score counter))
                         )
                    )
                    (setf counter 0)
                    (setf counter2 0)
                    )
                    (if (null (nth (nth 0 coordinate) (nth (nth 1 coordinate) game-board)))
                        (setf counter2 (+ counter2 1))
                    )
                )
            )
          )
        (if (>= (+ counter2 counter) 4)
            (if (>= counter 4) ;Up the weight on the counter because harder to make a diagonal move
                (setf total-score (- total-score 50))
                (setf total-score (- total-score counter))
             )
        )
    )
    (return-from heuristic-function-diagonal total-score)
)
(defun heuristic-function (game-board)
    (+ (heuristic-function-horizontal game-board) (heuristic-function-vertical game-board) (heuristic-function-diagonal game-board))
)

(defun get-all-valid-moves(game-board)
    (setf valid-moves '())
    (dotimes (i 5)
        (if (>= (get-next-row-from-col-hypo i game-board) 0)
                (push i valid-moves)
        )
    )
    (return-from get-all-valid-moves valid-moves)
)

;TREE FUNCTIONS
;I took bits from multiple tutorials on how to build a tree in LISP; they're used mostly so I can build a tree for the moves without my brain exploding

(defun make-tree (item)
    ;Create a new node with item
   (cons (cons item nil) nil)
)

(defun add-child (tree child)
    ;Set second node to be a child of the tree
   (setf (car tree) (append (car tree) child))
   tree
)

(defun first-child (tree)
    ;Get first child of tree if it has one
   (if (null tree)
      nil
      (cdr (car tree))
   )
)

(defun next-sibling (tree)
    ;Get next sibling of tree if it has one
   (cdr tree)
)

(defun data (tree)
    ;Get data of the tree
   (car (car tree))
)

;END TREE FUNCTIONS
(defun minmax-search(move-tree)
    ;Recursive minmax search
    ;If we have children, return the max/min of the two based on our move
    ;(print "DATA OF MOVE")
    ;(print (data move-tree))
    ;(print "Move made: ")
    ;(print (nth 2 (data move-tree)))
    (if (not (null (first-child move-tree)))
        (progn
        ;(print "Move has child!")
        ;Get a list of all children
        (setf all-children (list (first-child move-tree)))
        (setf looknode (next-sibling (first-child move-tree)))
        (loop while (not (null looknode)) do
            (progn
            (setf all-children (append all-children (list looknode)))
            (setf looknode (next-sibling looknode))
            )
        )
        (if (= (nth 1 (data move-tree)) 0)
            (progn
            ;(print "Player's turn, maximize!")
            ;Player turn, maximize
            ;Get the results of all of the children
            (setf results '())
            (loop for child in all-children do
                (progn
                (setf results (append results (list (minmax-search child))))
            )
            )
            ;(print "RESULTS OF MINMAX SEARCH: ")
            ;(print results)
            (setf maxval nil)
            (loop for result in results do
                (progn
                (if (or (null maxval) (> (car result) (car maxval)))
                    (progn
                    ;(print "Result found!")
                    ;(print result)
                    (setf maxval result)
                    )

                )
                )
            )
            (if (not (= (nth 2 (data move-tree)) -1))
                (return-from minmax-search (list (car maxval) (nth 2 (data move-tree))))
                (progn
                ;(print "SPECIAL SAUCE RETURN")
                ;(print maxval)
                (return-from minmax-search maxval)
                )

            )
            )
            (progn
            ;(print "AI's turn, minimize!")
            ;AI turn, minimize
            ;Get the results of all of the children
            (setf results '())
            (loop for child in all-children do
                (progn
                (setf results (append results (list (minmax-search child))))
            )
            )
            ;(print "RESULTS OF MINMAX SEARCH: ")
            ;(print results)
            (setf minval (car results))
            (loop for result in results do
                (progn
                (if (< (car result) (car minval))
                    (progn
                    ;(print "Result found!")
                    ;(print "Result: ")
                    ;(print result)
                    ;(print "Original minval: ")
                    ;(print minval)
                    (setf minval result)
                    )
                )
                )
            )
;;            (if (not (= (nth 2 (data move-tree)) -1))
;;                (progn
;;                (print "Non-ending minimum value found: ")
;;                (print minval)
;;                )
;;                (progn
;;                (print "Ending minimum value found.")
;;                (print "Result pool:")
;;                (print results)
;;                (print "Final:")
;;                (print minval)
;;                )
;;
;;            )

            (if (not (= (nth 2 (data move-tree)) -1))
                (return-from minmax-search (list (car minval) (nth 2 (data move-tree))))
                (progn
                ;(print "SPECIAL SAUCE RETURN")
                ;(print minval)
                (return-from minmax-search minval)
                )
            )
            )

        )
        )
        (progn
        ;We've reached an end node; calculate the heuristic and return it plus the move made to get here
        ;(print "No children!  Returning heuristic data....")
        (return-from minmax-search (list (heuristic-function (car (data move-tree))) (nth 2 (data move-tree))))
        )
    )
)

(defun ai-player ()
    (setf depth 4)
    (setf move-tree (make-tree (list *current_board* *turn* -1)))
    (setf current-node move-tree)
    (setf valid-moves-c (get-all-valid-moves *current_board*))
    (setf turn-c *turn*)
    (setf turn-queue (list '(current-node 0)))
    (setf cur-depth 0)
    ; Down to the set depth, generate all valid moves
    (loop while (not (null turn-queue)) do
        (progn
        ;(print "Turn queue init:")
        ;(print turn-queue)
        (loop for move in valid-moves-c do
            (progn
                ;For the node we are at generate all the moves we can make and add that board to the tree
                (add-child current-node (make-tree (list (make-move-hypothetical move (car (data current-node)) turn-c) (mod (+ turn-c 1) 2) move)))
            )
        )
        ;(print "Current node (after adding):")
        ;(print current-node)
        ;Add all of the children to the queue if we don't exceed depth
        (if (and (not (null (first-child current-node))) (< (+ cur-depth 1) depth))
            (progn
            ;(print "Current node has a child")
            (setf looknode (first-child current-node))
            ;(print "Looknode:")
            ;(print looknode)
            (loop while (not (null looknode)) do
                (setf turn-queue (append turn-queue (list (list looknode (+ cur-depth 1)))))
                ;(print "Appended looknode; next looknode:")
                (setf looknode (next-sibling looknode))
                ;(print looknode)
            )
            )
        )
        ;remove the first element from queue
        ;(print "Turn queue after adding:")
        ;(print turn-queue)
        (setf turn-queue (cdr turn-queue))
        ;(print "Turn queue after deleting front:")
        ;(print turn-queue)
        ;If not null, get the next node in turn-queue and set for next iteration
        (if (not (null turn-queue))
            (progn
            (setf current-node (car (car turn-queue)))
            (if(< cur-depth (nth 1 (car turn-queue)))
                (setf turn-c (mod (+ turn-c 1) 2))
            )
            (setf cur-depth (nth 1 (car turn-queue)))
            ;(print "AT DEPTH: ")
            ;(print cur-depth)
            (setf valid-moves-c (get-all-valid-moves (car (data current-node))))
            )
        )
        )

    )
    ;We now have a move tree; perform minmax search
    ;(print "Move tree:")
    ;(print move-tree)
    (setf move-to-make-data (minmax-search move-tree))
    ;(print move-to-make-data)
    (setf move-to-make (nth 1 move-to-make-data))
    ;Print the move, for game purposes
    (if (= move-to-make -1)
        (progn
        (format t "~%!!ERROR!! AI made an invalid move!  Making random valid move...~%")
        (setf move-to-make (car (get-all-valid-moves *current_board*)))
        )
    )
    (print move-to-make)
    (return-from ai-player move-to-make)
)
(defun play-game ()
    (print-board)
;;    (print "Current heuristic: ")
;;    (print "HORIZONTAL:")
;;    (print (heuristic-function-horizontal *current_board*))
;;    (print "VERTICAL:")
;;    (print (heuristic-function-vertical *current_board*))
;;    (print "DIAGONAL:")
;;    (print (heuristic-function-diagonal *current_board*))
;;    (print "TOTAL:")
;;    (print (heuristic-function *current_board*))

    (if (= *turn* 0)
        (progn
        (format t "~%Player's Turn (0-4): ")
        (setq input (read))
        (make-move input)
         ;Just for fun, if you want to make the ai play itself
         ;(setf ai-move (ai-player))
         ;(make-move ai-move)

        )
        (progn
         (format t "~%AI's Turn: (Thinking)")
         (setf ai-move (ai-player))
         (make-move ai-move)
        )
    )
    (if (check-win)
        (progn
        (if (= *turn* 0)
            (format t "~%AI Wins!")
            (format t "~%Player Wins!")
        )
        (print-board)
        (return-from play-game t)
        )
    )
    (if (null (get-all-valid-moves *current_board*))
        (progn
        (format t "Draw!")
        (print-board)
        (return-from play-game t)
        )
    )
    (play-game)
)
(defun connect-4 ()
    (play-game)
)

(connect-4)
