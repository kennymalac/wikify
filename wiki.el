(load-file "./tools.el")
(require 'cl)
(require 'generator)


(defun org-wiki-generate (tabs-json config-json)
  (let* ((tabs (parse-tabs tabs-json)) (config (parse-config config-json)) (categories (alist-get 'categories config)))
    (iter-do (val (categorize-from-tabs categories tabs))
      (let ((category (car val)) (filtered-tabs (cdr val)))
        (html-block-from-category category)
        (cl-loop for tab in filtered-tabs do (html-block-from-tab tab))
        ))))

;;;(dotimes ((html-block-from-bookmark (bookmark)))

;;(org-wiki-generate "../../../org/tabs.json" "categories_example.json")
