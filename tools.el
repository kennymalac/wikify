;; -*- lexical-binding: t -*-
(require 'json)
(require 'cl-lib)
(require 'generator)


(defun tab-has-keywords-p (keywords tab)
  (let ((ks (mapcar 'downcase keywords)) (tab-title (gethash "title" tab)))
    (seq-find (lambda (keyword)
                (cl-search keyword tab-title))
              ks)))


(defun tab-has-domains-p (domains tab)
  (let ((tab-url (gethash "url" tab)))
    (seq-find (lambda (domain)
                (string-match-p (regexp-quote (format "http|https\:\/\/(?:www)?%s(?:\/?.*)?" domain)) tab-url))
              domains)))

(defun tab-has-urlpattern-p (urlpatterns tab)
  ;; TODO
  nil)


(iter-defun categorize-from-tabs (categories tabs)
                                        ;(setq reduced copy-hash-table categories)
  (message "%s" categories)
  (let ((uncategorized-tabs (copy-sequence tabs)))
    (cl-labels ((filter-tabs (category)
                             ;;(message "%s" category)
                             (seq-filter
                              (lambda (tab)
                                (or (tab-has-keywords-p (gethash "keywords" category) tab)
                                    (tab-has-domains-p (gethash "domains" category) tab)
                                    (tab-has-urlpattern-p (gethash "urlpatterns" category) tab)))
                              uncategorized-tabs)))
      ;;(puthash category-tabs-stack)

      ;; Take each category, yield its tabs
       (dolist (category categories)
         (iter-yield (cons category (filter-tabs category)))

           ))))

;; (defun define-tag)

;; (defun hyperlink-tag)

;; (defun deconstruct-window ())

(defun html-block-from-category (category)
  (let ((name (gethash "name" category)))
    ;; #+ATTR_HTML: :title %s\n
    (insert (format "%s\n%s\n"
                    name (gethash "keywords" category)))))

(defun html-block-from-tab (tab)
  (let ((title (gethash "title" tab "")))
    (insert (format "[[file:%s]]\n#+ATTR_HTML: :title %s\n[[%s][%s]]\n"
                    (gethash "favIconUrl" tab "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGS6r69tiH8bFQLHVOlhXcmCvIkcbCIYmZEiZRY8a7ws5jKZbXqw") title (gethash "url" tab "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGS6r69tiH8bFQLHVOlhXcmCvIkcbCIYmZEiZRY8a7ws5jKZbXqw") title))))



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


