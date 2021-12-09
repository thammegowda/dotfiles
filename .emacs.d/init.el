
;;
(setq-default indent-tabs-mode nil)

;; change theme 
(load-theme 'tango-dark t)

(setq inhibit-startup-screen t)

;; enable mouse reporting
(xterm-mouse-mode 1)

;; enable clipboard integration with X
;; (setq x-select-enable-clipboard t)
;; https://www.emacswiki.org/emacs/CuaMode 
;;(cua-mode t)
;;(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
;;(transient-mark-mode 1) ;; No region when it is not highlighted
;;(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
