; this file contains initialization of global variables.

; Search Related Variables

(defvar *expand-bound*  0)    ; controls maximum number of expansions allowed till quit
(defvar *generate-bound*  0)  ; controls maximum number of generations allowed till quit
(defvar *open-bound*  0)      ; controls maximum size of open list allowed till quit

; DOMAIN RELATED Variables
(defvar *domain*           nil  "domain name = abtweak/tweak ")
(defvar *left-wedge-list*  nil  "left wedge list")
(defvar *tc-mode*          nil  "temporal coherence = t/nil")
(defvar *required-ops*     nil  "opids the user demands be included in plan")
(defvar *precond-new-est-only-list* nil)

; Planner Counter Variables

(defvar *num-expanded*      0    "global number of nodes expanded total")
(defvar *num-generated*     0    "global number of nodes generated total")
(defvar *max-succ-count*    0    "maximum node successors")
(defvar *max-confl-count*   0    "maximum u p conflicts")
(defvar *abs-node-count*    0    "number abstract nodes generated")
(defvar *mp-pruned*         0    "number nodes pruned via monotonic property.")

; Planner Choice Variables.

(defvar *shortcut-news-with-requireds?* t "limit news search to those in reqs?")
(defvar *planner-mode*             nil  "planner mode = tweak or abtweak")
(defvar *mp-mode*         nil  "mono. prop. = t/nil")
(defvar *abstract-goal-p*  nil  "nil if do not abstract goal conditions")
(defvar *drp-mode*          nil  "downward refinement mode = t / nil")
(defvar *left-wedge-mode*  nil  "left-wedge mode (use *lw-list*)")
(defvar *exist-est-heuristic* nil "used to rank possible establishers")
(defvar *subgoal-determine-mode*   
  nil  "determine user and precond in which way,  random / tree / stack/ highest")
(defvar *heuristic*          nil  "nil if no heuristic used.")
(defvar *use-primary-effect-p*   nil  "t if use primary effect of operators")
(defvar *abs-branching-limit* 0 "the maximum number of refinements each
abstract plan can have.")

(defvar *print-output-p*     nil  "quiet mode = t / nil")
(defvar *plan-debug-mode*    nil  "plan debug mode = t / nil")
(defvar *drp-debug-mode*     nil  "drp debug mode = t / nil")
(defvar *declob-debug-mode*  nil  "declob debug mode = t / nil")
(defvar *debug-mode*         nil  "debug mode = t / nil")
(defvar *debug-break-mode*   nil  "debug break mode = t / nil")

(defvar *abstract-goal-mode* nil) ;dp: these were undef'd in prev versions
(defvar *heuristic-mode*     nil)
(defvar *drp-stack*          nil)
(defvar *continue-p*         nil)
(defvar *confl-count*        nil)
(defvar *existing-only*      nil)
(defvar *output-stream*      nil)
(defvar *cpu-sec-limit*      nil)
(defvar *curr-level*         nil)
(defvar *critical-list*      nil)
(defvar *abs-backtracking-flag* nil)
(defvar *old-plan*           nil)
(defvar *new-refinement-p*   nil)

(defvar *sol*                nil) ; added by DP 7/97
(defvar *solution*           nil) ; These are global vars that were already
(defvar *internal-start-time* nil) ;in use but which had no initial declaration
(defvar *abs-branching-counts* nil)
(defvar *abs-ref-counts*     nil)
(defvar *abs-success-counts* nil)
(defvar *solution-limit*     nil)

(defun initialize-global-variables (

   planner-mode continue-p mp-mode abstract-goal-mode
   drp-mode left-wedge-mode subgoal-determine-mode exist-est-heuristic
   heuristic-mode use-primary-effect-p expand-bound
   generate-bound open-bound cpu-sec-limit
   existing-only abs-branching-limit tc-mode required-ops
   print-output-p
   plan-debug-stream drp-debug-mode declob-debug-mode
   debug-mode debug-break-mode
   )
  "initialize global variables."
  
  (setq *planner-mode*            planner-mode
        *mp-mode*                 mp-mode
        *abstract-goal-mode*      abstract-goal-mode
        *drp-mode*                drp-mode
        *left-wedge-mode*         left-wedge-mode
        *subgoal-determine-mode*  subgoal-determine-mode
        *exist-est-heuristic*     exist-est-heuristic
        *heuristic-mode*          heuristic-mode
        *use-primary-effect-p*    use-primary-effect-p
        *drp-stack*               nil

        *continue-p*              continue-p

        *expand-bound*            expand-bound
        *generate-bound*          generate-bound
        *open-bound*              open-bound

        *max-succ-count*          0 ; remember maximum successors at any 1 node
        *confl-count*             0 ; remember maximum conflicts for any u p
        *abs-node-count*          0 ; count of abtweak k level change nodes
        *mp-pruned*               0 ; count weak msp violation nodes discarded
        *existing-only*           existing-only
        *output-stream*           (or plan-debug-stream *standard-output*)
        *cpu-sec-limit*           cpu-sec-limit
        *tc-mode*                 tc-mode
        *required-ops*            required-ops

        *print-output-p*          print-output-p
	*plan-debug-mode*         (not (null plan-debug-stream))
        *drp-debug-mode*          drp-debug-mode
        *declob-debug-mode*       declob-debug-mode
        *debug-mode*              debug-mode
        *debug-break-mode*        debug-break-mode
	)

  (initialize-abs-branching-counts)
  (initialize-success-ref-counts)
  (initialize-abs-ref-counts)
  (when (or (equal *planner-mode* 'abtweak)
	    (equal *planner-mode* 'mr-crit))
	(setq *curr-level* (length *critical-list*)) )
  (setq *abs-branching-limit*   abs-branching-limit
	*abs-backtracking-flag* nil )

  )
