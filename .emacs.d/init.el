
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
(setq cabbage-repository (expand-file-name "~/.emacs.d/cabbage/"))
(load (concat cabbage-repository "cabbage"))
(load "~/.emacs.d/pillar-latex2pillar.el")
