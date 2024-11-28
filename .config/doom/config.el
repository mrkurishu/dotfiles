;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "mrkurishu"
       user-mail-address "mrkurishu@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/dox/org/")
(setq org-roam-directory (file-truename "~/dox/roam/"))

(setq org-roam-file-extensions '("org"))


(setq org-roam-capture-templates
      '(("m" "main" plain "%?"
         :if-new (file+head "main/${slug}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("r" "reference" plain "%?"
         :if-new (file+head "reference/${title}.org"
                            "#+title: ${title}\n")
         :immediate-finish t
         :unnarrowed t)
        ("a" "article" plain "%?"
         :if-new (file+head "articles/${title}.org"
                            "#+title: ${title}\n#+filetags: :article:\n")
         :immediate-finish t
         :unnarrowed t)
        ("d" "default" plain "%?"
         :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)
        ("g" "Genki Note" plain "%?"
         :if-new (file+head "reference/Genki/${slug}.org"
                            "#+title: ${title}\n#+date: %U\n")
         :unnarrowed t)))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/dox/roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package! org-roam-ui
  :after org-roam
  :hook (org-roam-mode . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package vterm
  :ensure t
  :commands vterm)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; CUSTOM BY ME
;;
;; BEACON
;; Shine cursor when scrolling
(beacon-mode 1)
;;
;; BOOKMARKS
;; Save locations in files or buffers that you can quickly return later.
(setq bookmark-default-file "~/.config/doom/bookmarks")

(map! :leader
      (:prefix ("b". "buffer")
       :desc "List bookmarks"                          "L" #'list-bookmarks
       :desc "Set bookmark"                            "m" #'bookmark-set
       :desc "Delete bookmark"                         "M" #'bookmark-set
       :desc "Save current bookmarks to bookmark file" "w" #'bookmark-save))
;;
;; GLOBAL AUTO REVERT ibuffer
;; Avoid out of sync buffer caused or changed by another program
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)
;; ibuffer keybindings
(evil-define-key 'normal ibuffer-mode-map
  (kbd "f c") 'ibuffer-filter-by-content
  (kbd "f d") 'ibuffer-filter-by-directory
  (kbd "f f") 'ibuffer-filter-by-filename
  (kbd "f m") 'ibuffer-filter-by-mode
  (kbd "f n") 'ibuffer-filter-by-name
  (kbd "f x") 'ibuffer-filter-disable
  (kbd "g h") 'ibuffer-do-kill-lines
  (kbd "g H") 'ibuffer-update)

;; Move deleted files to TRASH
(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")
;;
;; MOUSE SUPPORT
;; adding mouse support for terminal version
(xterm-mouse-mode 1)
;;
;
;; Org-Agenda
;;
(after! org
  (setq org-agenda-files '("~/dox/org/agenda.org"
                           "~/docs/org-files/work.org")))
(setq
   ;; org-fancy-priorities-list '("[A]" "[B]" "[C]")
   ;; org-fancy-priorities-list '("❗" "[B]" "[C]")
   org-fancy-priorities-list '("🟥" "🟧" "🟨")
   org-priority-faces
   '((?A :foreground "#ff6c6b" :weight bold)
     (?B :foreground "#98be65" :weight bold)
     (?C :foreground "#c678dd" :weight bold))
   org-agenda-block-separator 8411)

(setq org-agenda-custom-commands
      '(("v" "A better agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (tags "PRIORITY=\"B\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Medium-priority unfinished tasks:")))
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority unfinished tasks:")))
          (tags "customtag"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Tasks marked with customtag:")))

          (agenda "")
          (alltodo "")))))
; RAINBOW mode
;; Add color to hex value
(define-globalized-minor-mode global-rainbow-mode rainbow-mode
  (lambda ()
    (when (not (memq major-mode
                (list 'org-agenda-mode)))
     (rainbow-mode 1))))
(global-rainbow-mode 1 )
;
;; SPLITS
;; open slipts on the right always
(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window" "b c" #'clone-indirect-buffer-other-window)
;;
;; END of file
;;
;; TESTING - ENABLE DESKTOP NOTIFICATIONS
;; in development....

;; add org-alert configuration
;;(use-package! org-alert
;;  :config
;;  (setq alert-default-style 'libnotify)) ; or 'notifications' for macOS

;;(notifications-notify :title "Test!"
;;                     :body "This is a test!")

;;(use-package org-alert
;;    :ensure t
;;    :custom (alert-default-style 'libnotify)
;;    :config
;;    (setq org-alert-interval 300
;;          org-alert-notification-title "Org Alert Reminder!")
;;    (org-alert-enable))

;; Refresh agenda when org files are loaded
;;(add-hook 'org-mode-hook 'org-agenda-list)

;; Enable desktop notifications
(require 'notifications)

;; Example function to send a notification
(defun my/notify (title body)
  "Send a desktop notification with TITLE and BODY."
  (notifications-notify
   :title title
   :body  body
   :timeout 5000))  ;; Timeout in milliseconds

;; Example usage
(my/notify "Doom-Emacs" "Hey! Doom is running!")

;; Org Notifications
(require 'org)
(require 'notifications)

;; Send a notification with a specified timeout (duration)
(defun my/org-send-notification (title body timeout)
  "Send a desktop notification with TITLE, BODY, and TIMEOUT."
  (notifications-notify
   :title title
   :body  body
   :timeout timeout))  ;; Timeout in milliseconds

;; Notify 30 minutes before the event
(defun my/org-notify-before-event (time)
  "Send a notification 30 minutes before the Org mode event TIME."
  (let* ((current-time (current-time))
         (time-left (time-to-seconds (time-subtract time current-time)))
         (thirty-minutes (* 30 60)))
    (when (and (<= time-left thirty-minutes) (> time-left 0))
      (my/org-send-notification
       "Org Mode Reminder"
       (format "Reminder: %s in 30 minutes" (or (org-get-heading t t t t)))
       30000))))  ;; 30 seconds

;; Notify at the exact time of the event
(defun my/org-notify-on-event (time)
  "Send a notification when the Org mode event TIME arrives."
  (let* ((current-time (current-time))
         (time-left (time-to-seconds (time-subtract time current-time))))
    (when (<= time-left 0)
      (my/org-send-notification
       "Org Mode Reminder"
       (format "Event started: %s" (or (org-get-heading t t t t)))
       30000))))  ;; 30 seconds

;; Set up notifications for deadlines and scheduled tasks
(defun my/org-setup-notifications ()
  "Set up notifications for Org mode deadlines and scheduled tasks."
  (add-hook 'org-deadline-warning-functions
            (lambda (&rest _)
              (let ((deadline-time (org-get-deadline-time)))
                (my/org-notify-before-event deadline-time)
                (my/org-notify-on-event deadline-time))))
  (add-hook 'org-scheduled-hook
            (lambda ()
              (let ((scheduled-time (org-get-scheduled-time)))
                (my/org-notify-before-event scheduled-time)
                (my/org-notify-on-event scheduled-time)))))

;; Initialize the notifications setup
(my/org-setup-notifications)

;; Set Flyspell to use English by default
(add-hook 'flyspell-mode-hook
          (lambda () (ispell-change-dictionary "en")))

;; PDF TOOLS
(after! pdf-tools
  (pdf-tools-install) ; Install pdf-tools
  (setq pdf-view-resize-factor 1.1) ; Set the zoom factor
  (setq pdf-view-use-scaling t)) ; Use scaling

;; CALENDAR mod
;; Start week on Monday instead of Sunday
(setq calendar-week-start-day 1)

;; ADD SOME TRANSPARENCY TO DOOM EMACS
;; Set the frame transparency
(set-frame-parameter (selected-frame) 'alpha '(95 . 95))  ;; 95% opaque (5% transparent)

;; Adjust transparency for all frames
(add-to-list 'default-frame-alist '(alpha . (95 . 95)))  ;; Same transparency as above

;; Optional: Set transparency when Emacs is inactive
(defun my/set-inactive-frame-alpha (alpha)
  "Set the transparency of inactive frames to ALPHA."
  (set-frame-parameter (selected-frame) 'alpha alpha))

;; Make inactive frames more transparent (optional)
(add-hook 'focus-out-hook (lambda () (my/set-inactive-frame-alpha '(85 . 85))))
(add-hook 'focus-in-hook (lambda () (my/set-inactive-frame-alpha '(95 . 95))))
