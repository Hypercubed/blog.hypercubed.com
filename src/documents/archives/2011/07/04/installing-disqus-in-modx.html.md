---
title: "Installing DISQUS in MODx"
post_name: "installing-disqus-in-modx"
guid: 'http://blog.hypercubed.com/?p=701'
status: "publish"
date: '2011-07-04 00:29:33'
post_id: '701'
tags: [ 'Site' ]
---
A few days ago I mentioned upgrading my (very neglected) main site (<a href="http://hypercubed.com">hypercubed.com</a>) to <a href="http://modx.com/">MODx revolution</a>.  I didn’t bother migrating the commenting system from the old site because it was rarely used.  I didn't plan on implementing a commenting system at all on revolution.  Then I had the simple idea of using <a href="http://disqus.com/">DISQUS</a> (pronounced <em>discuss</em>).  DISQUS is that cross site commenting system you've undoubtedly seen on numerous blogs.  For visitors it allows posting of comments using any one of several log-ins (twitter, facebook, etc) and, if they are using a DISQUS account, track comments across multiple websites.

As a site manager or blog owner you need to create an account at <a href="http://disqus.com/">disqus.com</a> then follow the simple instructions for installing the commenting system on your website or blog.  Unfortunately, you will not find instructions for MODx.  I'm sure most people running MODx are skilled enough to figure this out but here is my solution.

The code below is what DISQUS calls the <a href="http://docs.disqus.com/developers/universal/">universal code</a> (with a slight modification).  This is a short JavaScript chunk that adds the DISQUS system to your website.  On the fifth line you need to replace "example" with the forum shortname you get when you registered your site with DISQUS.  Line seven is an identifiers used to keep comments across your site separate.  Here I am using the MODx page id as a unique identifier.  You can also key off the <code>[[*alias]]</code> but I what the ability to move pages (changing the alias) without orphaning the comments.

```
<div id="disqus_thread"></div>
<script type="text/javascript">
    /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
    var disqus_shortname = 'example'; // required: replace example with your forum shortname

    // The following are highly recommended additional parameters. Remove the slashes in front to use.
    var disqus_identifier = 'post_[[*id]]';

    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>
```

Now, simply adding this text to the template (<a href="http://codingpad.maryspad.com/2011/01/23/modx-revolution-for-complete-beginners-part-4-working-with-templates/">working with templates</a>) will enable comments on my site.  However, I don't want to have comments on every page.  So I placed the above HTML into a chunk (<a href="http://codingpad.maryspad.com/2011/01/30/modx-revolution-for-complete-beginners-part-5-working-with-chunks/">working with chunks</a>) called <code>[[$comments?]]</code>.  Then I created a template variable (<a href="http://codingpad.maryspad.com/2011/02/07/modx-revolution-for-complete-beginners-part-6-working-with-template-variables/">working with template variables</a>) called `[[*Comments]]`.  The `[[*Comments]]` template variable has an <em>input type</em> of <code>Check Box</code>, an <em>input options values</em> of <code>Enabled==1</code>, and a <em>default value</em> of <code>0</code>.

Then in my template, where I wish to have the DISQUS comments appear, I added the following code:

```[[If? &subject=`[[*Comments]]` &operand=`1` &then=`[[$comments?]]`]]```

This tag uses the <a href="http://rtfm.modx.com/display/ADDON/If"><em>If</em> snippet</a> to check if the <code>[[*Comments]]</code> template variable is enabled.  If it is the DISQUS comments are shown.  With this I can selectively turn comments on and off on individual pages.  

This is just another example of the flexibility in MODx.

