(load-file "./tools.el")
(require 'cl)
(require 'generator)


(defun org-wiki-generate (config-json &rest tabs-jsons)
  (let* ((tabs (apply 'append (cl-loop for tabs-json in tabs-jsons collect (parse-tabs tabs-json))))
         (config (parse-config config-json))
         (categories (alist-get 'categories config)))

    (html-block-navigation-from-categories categories)

    (iter-do (val (categorize-from-tabs categories tabs))
      (let ((category (car val)) (filtered-tabs (cdr val)))
        (html-block-from-category category)
        (cl-loop for tab in filtered-tabs do (html-block-from-tab tab))
        ))))

;;example command: (org-wiki-generate "../../../org/tabs.json" "categories_example.json")
