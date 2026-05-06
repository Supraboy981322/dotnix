;me emacs config
;  (mostly just curiosity, at the moment)

;remove the annoying bell sound
(setq
  ring-bell-function 'ignore)

;set the config to a sane directory
(defvar
  config_dir
  "~/.config/emacs/"
  "emacs config dir")

; TODO: what the hell was this for?
(setq custom-file
  (concat config_dir "custom.el"))

;packages
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
  '("gnu" . "https://elpa.gnu.org/packages") t)
(package-initialize)

;use-package stuff
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq
  use-package-always-ensure t)

;evil mode
(unless (package-installed-p 'evil)
	(package-install 'evil))
(require 'evil)
(evil-mode 1)

;theme
(use-package
  ayu-theme ; TODO: the colors don't match NeoVim for this theme
  :config (load-theme 'ayu-dark t))

;hide the ui (why is this even present by default?)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq
	inhibit-startup-screen t)

(add-to-list 'default-frame-alist
	'(font . "Cascadia Code NF-12"))

;move the autosave and backup files
;	 to separate directories
(setq
 backup-directory-alist
 `((".".
    ,(expand-file-name
			"tmp/backups/"
			user-emacs-directory))))
(setq
 auto-save-file-name-transforms
 `((".*"
    ,(expand-file-name
	  	"tmp/auto-saves/"
			user-emacs-directory) t)))
(make-directory
	(expand-file-name
		"tmp/backups"
		user-emacs-directory) t)
(make-directory
	(expand-file-name
		"tmp/auto-saves/"
		user-emacs-directory) t)

;line numbers
(global-display-line-numbers-mode 1)
(setq
	display-line-numbers-type
	'relative)

;fix stupid whitespace behavior
(global-set-key
	(kbd "TAB")
	'self-insert-command)
(setq-default
	indent-tabs-mode nil)
(setq-default
	tab-width 2)
;I HATE it when an editor does this
(electric-indent-mode 0)
(setq-default
	evil-maybe-remove-spaces nil)


;various "modes"
(use-package zig-ts-mode
  :vc ( :url "https://codeberg.org/meow_king/zig-ts-mode"
				:rev :newest))
