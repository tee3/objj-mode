;;; Objective-J programming language
(eval-after-load "cc-mode.el"
  (defconst cappuccino-objj-style
    '((c-basic-offset . 4)
      (tab-width . 8)
      (indent-tabs-mode . nil)
      (c-offsets-alist
       (substatement-open . 0))))

  (define-derived-mode objj-mode objc-mode
    "Objective-J"
    "Major mode for editing Objective-J files.")

  (add-to-list 'auto-mode-alist '("\\.j\\'" . objj-mode))

  (eval-after-load "flycheck.el"
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

  (eval-after-load "compile.el"
    (add-to-list 'compilation-error-regexp-alist-alist
                 '(objj-acorn "^\\(WARNING\\|ERROR\\) line \\([0-9]+\\) in file:\\([^:]+\\):\\(.*\\)$" 3 2))
    (add-to-list 'compilation-error-regexp-alist 'objj-acorn))

  (add-hook 'c-mode-common-hook
            (lambda ()
              (c-add-style "cappuccino" cappuccino-objj-style t)))
  (add-hook 'objj-mode-hook
            (lambda ()
              (c-set-style "cappuccino"))))
