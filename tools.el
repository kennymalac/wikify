;; -*- lexical-binding: t -*-
(require 'json)
(require 'cl-lib)
(require 'generator)

(defvar blacklist-patterns '("chrome\:\/\/.*" "about\:\\(?:blank\\|config\\|newtab\\|\\addons\\|preferences\\|debugging\\)"))

(defun tab-has-keywords-p (keywords tab)
  (let ((ks (mapcar 'downcase keywords)) (tab-title (downcase (gethash "title" tab))))
    (seq-find (lambda (keyword)
                (cl-search keyword tab-title))
              ks)))

(defun matches-urlpattern-p (tab-url urlpattern)
  (string-match-p urlpattern tab-url))

(defun tab-in-urlpatterns-p (urlpatterns tab)
  (seq-some (apply-partially 'matches-urlpattern-p (gethash "url" tab "")) urlpatterns))

(defun tab-has-domains-p (domains tab)
  (let ((tab-url (gethash "url" tab)))
    (seq-find (lambda (domain)
                (string-match-p (format "\\(\\?\\:http\\|https\\)\\:\\/\\/\\(\\?\\:www\\)?%s.*?" domain) tab-url))
              domains)))

(defun filter-unique-tabs (tabs)
  (let ((tab-urls (seq-uniq (mapcar (lambda (tab) (gethash "url" tab)) tabs)))
        (used-urls '()))

    (seq-filter (lambda (tab)
                  (let ((tab-url (gethash "url" tab)))
                    (unless (seq-position used-urls tab-url) (push tab-url used-urls))))
                tabs)))


(iter-defun categorize-from-tabs (categories tabs)
  (let ((uncategorized-tabs (filter-unique-tabs tabs)))
    (cl-labels
        ((filter-tabs (category)
                      (let ((categorized-tabs
                             (seq-filter
                              (lambda (tab)
                                ;; Cannot be in blacklisted URLs, and should fit in at least 1 category specification
                                (and (not (tab-in-urlpatterns-p blacklist-patterns tab))
                                     (or (tab-has-keywords-p (gethash "keywords" category '()) tab)
                                         (tab-has-domains-p (gethash "domains" category '()) tab)
                                         (tab-in-urlpatterns-p (gethash "urlpatterns" category '()) tab))))
                              uncategorized-tabs)))

                        (setq uncategorized-tabs (seq-difference uncategorized-tabs categorized-tabs))
                        categorized-tabs)))

      ;; Take each category, yield its tabs
      (dolist (category categories)
        (iter-yield (cons category (filter-tabs category)))))))

;; (defun define-tag)

;; (defun hyperlink-tag)

;; (defun deconstruct-window ())

(defun html-block-from-category (category)
  (let ((name (gethash "name" category)))
    ;; #+ATTR_HTML: :title %s\n
    (insert (format "@@html:<div id=\"%s\" class=\"category-title\">@@%s\n%s@@html:</div>@@\n"
                    (gethash "href" category) name (gethash "keywords" category)))))

(defun html-block-from-tab (tab)
  (let ((title (gethash "title" tab "")))
    (insert (format "#+ATTR_HTML: :title %s\n@@html:<img class=\"favicon\" src=\"%s\" />@@ [[%s][%s]]\n"
                    title (gethash "favIconUrl" tab "") (gethash "url" tab "") title))))

(defun html-block-navigation-from-categories (categories)
  (dolist (category categories)
    (let ((name (gethash "name" category)))
      ;; #+ATTR_HTML: :title %s\n
      (insert (format "@@html:<a href=\"\#%s\" class=\"category-title\">@@%s\n@@html:</a>@@\n"
                      (gethash "href" category) name)))))


;; Complex parsing comes later?
(defun parse-config (config-data)
  (setq lexical-binding nil)
  (let* ((json-object-type 'hash-table)
         (json-array-type 'list)
         (json-key-type 'string)
         (parsed-data (json-read-file config-data)))
    ;; TODO windows . (gethash Windows parsed-data)
    `((categories . ,(gethash "Categories" parsed-data)) (windows . windows))))

(defun parse-tabs (tabs-data)
  (setq lexical-binding nil)
  (let* ((json-object-type 'hash-table)
         (json-array-type 'list)
         (json-key-type 'string)
         (parsed-data (json-read-file tabs-data)))
    parsed-data)) ;; TODO parse-open-windows..


