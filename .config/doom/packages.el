;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;; (package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;; (package! another-package
;;   :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;; (package! this-package
;;   :recipe (:host github :repo "username/repo"
;;            :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;; (package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;; (package! builtin-package :recipe (:nonrecursive t))
;; (package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
;; (package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;; (package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;; (unpin! pinned-package)
;; ...or multiple packages
;; (unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;; (unpin! t)
;;
;; ADDED MY ME
;; Integrates the aspell spell checker with Flycheck, a modern on-the-fly syntax checking extension for Emacs. It provides spell checking in buffers using aspell.
(package! flycheck-aspell)

;; A calendar framework for Emacs. It provides various calendar views and integrates with other calendar packages to display events and schedules
(package! calfw)

;; Adds support for displaying Org-mode agenda items within the calfw calendar framework. This allows you to view and manage your Org-mode agenda directly in the calendar view.
(package! calfw-org)

;; Highlights the cursor's position with a visual beacon effect, making it easier to locate the cursor in large buffers or when scrolling
(package! beacon)

;; Automatically export (tangles) source code blocks to their files
(package! org-auto-tangle)

;; Web tools for Org-mode
(package! org-web-tools)

;; Enable rainbow-mode for hex - show colors
(package! rainbow-mode)

;; Resize windows
(package! resize-window)

;; Displays word count information
(package! wc-mode)

;; Enable desktop notifications
(package! notifications)
;; (package! org-alert)

;; (package! alert)
;; (package! cl-lib)
;; PDF Tools
(package! pdf-tools)
(package! org-roam-ui
  :recipe (:host github :repo "org-roam/org-roam-ui"))
(package! vterm)
