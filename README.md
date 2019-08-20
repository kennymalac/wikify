# wikify
Takes an open set of firefox tabs and saves it to JSON. With this JSON you can convert it to an org-mode file fairly easily. (albeit a not-so pretty one that generates to pretty looking HTML)  
  
This is an a pretty primitive state right now, but eventually it should prove useful to more people than just myself.

## motivations
I had a bad situation where I somehow managed to rack up like 1100 tabs or so. This was a hindrance until Firefox 57 (because it made starting sessions like that much faster). However, I also lost out on one of my favorite addons (Storybook Pro). I'm trying to minimally replicate what that addon gave me in terms of being able to categorize sets of tabs. I have plans to do more with it (like HTML caching among other things) but that will come with time. 

## usage
Right now I'm just evalling the lisp code directly in an org-mode buffer, i.e. not as an extension. The webextension portion is literally just a few lines of JavaScript that gets the current tab set and saves it as json. Then I run copy(tabsData) in the webextension debugger to copy it to my clipboard, which I copy into a json file which my elisp code loads with json.el, which calls an immediate-mode insert procedure in an iterator that generates HTML with all the tabs categorized.
