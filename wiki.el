(eval-when-compile (require 'cl 'generator))


(defun org-wiki-generate (tabs-json config-json)
  (let* ((tabs (parse-tabs tabs-json)) (config (parse-config config-json)) (categories (assoc 'categories config))))
    (iter-do (val (categorize-from-tabs categories tabs))
             (cl-destructuring-bind (category filtered-tabs) 'val
               (html-block-from-category category)
               (cl-loop for tab in (filtered-tabs) do (html-block-from-tab tab) do (forward-line 1)))))

;;;(dotimes ((html-block-from-bookmark (bookmark)))
