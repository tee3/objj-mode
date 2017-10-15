;;; Objective-J programming language
(use-package objc-mode
  :preface
  (defconst cappuccino-objj-style
    '((c-basic-offset . 4)
      (tab-width . 8)
      (indent-tabs-mode . nil)
      (c-offsets-alist
       (substatement-open . 0))))
  :mode
  (("\\.j\\'" . objj-mode))
  :init
  (define-derived-mode objj-mode objc-mode
    "Objective-J"
    "Major mode for editing Objective-J files.")
  (use-package flycheck
    :ensure t
    :pin melpa
    :config
    (flycheck-define-checker objj-capp-lint
      "A flycheck checker for Objective-J based on capp_lint."
      :command
      ("capp_lint" source)
      :error-patterns
      ((warning line-start line ": " (message) "." line-end))
      :modes
      (objj-mode))
    (add-to-list 'flycheck-checkers 'objj-capp-lint)
    (add-hook 'objj-mode-hook (lambda ()
                                (flycheck-select-checker 'objj-capp-lint))))
  (use-package compile
    :config
    (add-to-list 'compilation-error-regexp-alist-alist
                 '(objj-acorn "^\\(WARNING\\|ERROR\\) line \\([0-9]+\\) in file:\\([^:]+\\):\\(.*\\)$" 3 2))
    (add-to-list 'compilation-error-regexp-alist 'objj-acorn)))
; @todo this should be up in use-package, but are not being called
(add-hook 'c-mode-common-hook
          (lambda ()
            (c-add-style "cappuccino" cappuccino-objj-style t)))
(add-hook 'objj-mode-hook
          (lambda ()
            (c-set-style "cappuccino")))
