---
title: "Visual Studio cannot debug [MapPoint] Add-In if .NET 2.0 runtime installed"
post_name: "visual-studio-cannot-debug-mappoint-add-in-if-net-20-runtime-installed"
guid: 'http://www.hypercubed.com/wordpress/?p=10'
status: "publish"
date: '2005-04-30 00:16:00'
post_id: '10'
tags: [ 'CoordEx' ]
---
I've done a lot of programming in <a href="http://msdn.microsoft.com/vbasic/">MS Visual Basic</a> using version 6.0 but recently I have been switching over to VB.NET 2003. One application (<a href="http://www.hypercubed.com/projects/coordex/">Coordinate Exchange</a>) that I wrote in 6.0 was an plug-in for MapPoint. This application has been been fairly popular among MapPoint users and for a while now I've wanted to convert it to a more stable VB.net version. I knew converting wouldn't be easy but I couldn't even get past the first gate. For nearly a year now I had been trying to create an add-in for MapPoint using VB.NET and constantly running into a brick wall. I could setup the application just fine (see instructions <a href="http://www.mp2kmag.com/a119--metropolitan.statistical.areas.msa.mappoint.html">here</a>) but for some reason I could never get the runtime debugging to work. The application would run fine if installed but always crashed silently when entering debug mode. I had literally been trying to figure this out for the past year (from as early as May 10, 2004)... I searched the web, posted multiple requests for help to <a href="http://www.mp2kmag.com/mappoint/discussion/viewtopic.asp?t=5578&amp;highlight=">forums</a> and <a href="http://groups-beta.google.com/group/microsoft.public.mappoint">news groups</a>, and even sent an e-mail to a MapPoint developer (<a href="http://www.csthota.com/csthota/">Chandu Thota</a>) and never got any response. I was really shocked that nobody appeared to be having the same problem. Was it just me? I tried on several of my machines and each had the same problem. I was stuck. 
<br /> 
<br />I'm glad to say that I've finally solved it. Or actually somebody else solved it for a similar situation and I finally came across <a href="http://www.tech-archive.net/Archive/Office/microsoft.public.office.developer.com.add_ins/2005-01/0134.html">the answer</a>. See the problem was not me or my application but the fact that every machine I owned had Microsoft .NET Framework version 2.0 installed. When MapPoint would open the addin it would load the version 2.0 by default. Visual Basic.NET 2003 would be attempting to debug assuming version 1.1. The application would then crash without any error message. 
<br /> 
<br />The solution is actually very simple. You have to instruct MapPoint to use the NET Framework 1.1. To do this create a file in the MapPoint directory (the one containing MapPoint.exe) named MapPoint.exe.config. The file should contain the following text: 
<br /> 
<p> 
</p> 
&lt;configuration&gt;
  &lt;startup&gt;
    &lt;supportedRuntime version="v1.1.4322"/&gt;
  &lt;/startup&gt;
&lt;/configuration&gt;
<p> 
</p> 
<br />After that all MP plug-ins run using 1.1 runtime and there are no more crashes in debug mode. Now all I have to do is spend the next year or so and convert all my 6.0 code to .NET. Wish me luck. 
