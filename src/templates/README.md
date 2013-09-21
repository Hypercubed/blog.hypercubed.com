Drafting and publishing a blog post (in [docpad](https://github.com/bevry/docpad)) using [frontman](https://github.com/Hypercubed/frontman)
===

Create a new blog post:

    $  frontman new.html.md -t src/templates/draft_post.cson -o .
    info:    Writing  [...]\src\drafts\new.html.md
    It's saved!
  
Publishing blog post:

    $ frontman  src/drafts/new.html.md -t src/templates/publish_post.cson -o .
    info:    Writing  [...]\src\documents\archives\2013\09\20\new.html.md
    It's saved!