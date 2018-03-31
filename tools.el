(eval-when-compile (require 'generator))


(defun tab-has-keywords-p (keywords tab)
  (let ((ks apply #'downcase (gethash "keywords")) (tab-title (gethash "title" tab)))
    (seq-find (lambda (keyword)
                (cl-search keyword tab-title))
              ks)))


(defun tab-has-domains-p (domains tab)
  (let (tab-domain (gethash "domain" tab))
    (seq-find (lambda (domain)
                (string-match-p (regexp-quote (format "http|https\:\/\/(?:www)?%s(?:\/?.*)?" domain) tab-domain)))
              domains)))

(defun tab-has-urlpattern-p (urlpatterns tab)
  (nil))


(iter-defun categorize-from-tabs (categories tabs)
  ;(setq reduced copy-hash-table categories)
  (defvar uncategorized-tabs (copy-sequence tabs))

  (labels ((filter-tabs (category)
                        (seq-remove
                         (lambda (tab)
                           (or (tab-has-keywords-p (gethash "keywords" category) tab)
                               (tab-has-domains-p (gethash "domains" category) tab)
                               (tab-has-urlpattern-p (gethash "urlpattern" category) tab)))
                         (uncategorized-tabs))))
                        ;;(puthash category-tabs-stack)

    ;; Take each category, yield its tabs
    (dolist (category categories)
      (iter-yield (category (filter-tabs category))))))

;; (defun define-tag)

;; (defun hyperlink-tag)

;; (defun deconstruct-window ())

(defun html-block-from-category (category)
  (let (name (gethash "name" category))
    (insert (format "#+ATTR_HTML: :title %s\n%s\n%s"
                    (name) (name) (gethash "keywords" category)))))

(defun html-block-from-tab (tab)
  (insert (format "#+ATTR_HTML: :title %s\n[[%s]] [[%s]]"
                  (gethash "title" tab) (gethash "favIconUrl" tab) (gethash "url" tab))))



;; Complex parsing comes later?
(defun parse-config (config-data)
  (let (parsed-data (json-read-string-from-string config-data))
    ;; TODO windows . (gethash Windows parsed-data)
    (return ((categories . (gethash "Categories" parsed-data)) ))))

(defun parse-tabs (tabs-data)
  (return (json-read-string-from-string tabs-data))) ;; TODO parse-open-windows..


