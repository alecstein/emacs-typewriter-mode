(defvar tw-ignored-commands '(mouse-drag-region
                                  mouse-set-region
                                  mouse-set-point
                                  widget-button-click
                                  scroll-bar-toolkit-scroll)
  "After these commands recentering is ignored.
This is to prevent unintentional jumping (especially when mouse
clicking). Following commands (except the ignored ones) will
cause an animated recentering to give a feedback and not just
jumping to the center."
  )

(defun tw-ignored-command-p ()
  "Check if the last command was one listed in TW-IGNORED-COMMANDS."
  (member this-command tw-ignored-commands))

(defun tw-mouse-drag-movement-p ()
  "Check if the last input event corresponded to a mouse drag event."
  (mouse-movement-p last-command-event))

(defvar tw-inhibit-centering-when '(tw-ignored-command-p
				    tw-mouse-drag-movement-p))
(defun line-change ()
  (unless (seq-some #'funcall tw-inhibit-centering-when)
  (recenter)))

(define-minor-mode typewriter-mode
  "Makes the cursor stay vertically in a defined
position (usually centered)."
  :init-value nil
  :lighter " ☯"
  :keymap
  '(
    ([wheel-up] . previous-line)
    ([wheel-down] . next-line))
  (cond
   (typewriter-mode
    (add-hook 'post-command-hook 'line-change t t))
   (t
    (remove-hook 'post-command-hook 'line-change t))))

(provide 'typewriter-mode)
