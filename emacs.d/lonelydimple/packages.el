(require 'package)

(defun lonelydimple/flatten (x)
  "Flatten a list."
  (cond ((null x) nil)
        ((listp x) (append (lonelydimple/flatten (car x)) (lonelydimple/flatten (cdr x))))
        (t (list x))))

(dolist (repo '(("elpa"      . "http://tromey.com/elpa/")
                ("marmalade" . "http://marmalade-repo.org/packages/")
                ("melpa"     . "http://melpa.milkbox.net/packages/")))
  (add-to-list 'package-archives repo))

(defun lonelydimple/package-refresh-and-install (name)
  "Ensure we have a fresh package list, then install."
  (package-refresh-contents)
  (package-install name))

(defun lonelydimple/package-install-unless-installed (name)
  "Install a package by name unless it is already installed."
  (or (package-installed-p name) (lonelydimple/package-refresh-and-install name)))

(defun lonelydimple/package-version-for (package)
  "Get the version of a loaded package."
  (package-desc-vers (cdr (assoc package package-alist))))

(defun lonelydimple/package-delete-by-name (package)
  "Remove a package by name."
  (package-delete (symbol-name package)
                  (package-version-join (lonelydimple/package-version-for package))))

(defun lonelydimple/package-delete-unless-listed (packages)
  "Remove packages not explicitly declared."
  (let ((packages-and-dependencies (lonelydimple/packages-requirements packages)))
    (dolist (package (mapcar 'car package-alist))
      (unless (memq package packages-and-dependencies)
        (lonelydimple/package-delete-by-name package)))))

(defun lonelydimple/packages-requirements (packages)
  "List of dependencies for packages."
  (delete-dups (apply 'append (mapcar 'lonelydimple/package-requirements packages))))

(defun lonelydimple/package-requirements (package)
  "List of recursive dependencies for a package."
  (let ((package-info (cdr (assoc package package-alist))))
     (cond ((null package-info) (list package))
           (t
            (lonelydimple/flatten
             (cons package
                   (mapcar 'lonelydimple/package-requirements
                           (mapcar 'car (package-desc-reqs package-info)))))))))

(defun lonelydimple/package-install-and-remove-to-match-list (&rest packages)
  "Sync packages so the installed list matches the passed list."
  (package-initialize)
  (condition-case nil ;; added to handle no-network situations
      (mapc 'lonelydimple/package-install-unless-installed packages)
    (error (message "Couldn't install package. No network connection?")))
  (lonelydimple/package-delete-unless-listed packages))

(lonelydimple/package-install-and-remove-to-match-list
 'magit
 'markdown-mode
 'hemisu-theme
 )
