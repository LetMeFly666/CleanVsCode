# CleanVsCode

[English | [简体中文](language/zh/)]
 
Clean VisualStudio Code's Cache, which could be even more than 5G after 1 week's usage.

**Why is the lightweight vscode uses more and more memory? Why does it occupy 10G of my C disk? How to clean the vscode cache painlessly? Tell you how to slim down for C disk hand in hand**

VsCode is a **lightweight** editor

But you will soon find that the "lightweight" vscode is not lightweight.

I was shocked by statistics before which I don't know about. After using for a period of time, vscode occupied 10G+ space of my C disk!

Oh God, then I decided to manage vscode and make it really lightweight.

### Space occupancy analysis of VsCode

The space occupied by VsCode mainly includes four parts (the following is the statistical results when I wrote this blog):

1. ```Installation directory of the program```: about 350M
2. ```%userprofile%\.vscode```：up to 800M. Mainly for: each expansion. The vscode uninstallation extension does not seem to delete the files on the hard disk, so it is very large and there are many unused files.
3. ```%userprofile%\AppData\Local\Microsoft\vscode-cpptools\ipch  ```: 4G can be achieved in a period of time, which is related to the C(++) language. You can delete it directly after closing the program. Users who do not use vscode to edit C/C++ may not suffer from this.
4. ```%userprofile%\AppData\Roaming\Code```: 2G+ stores user data, configuration, etc. (other directories can be configured by adding -- user data dir newdir when startup)

Places that can be deleted regularly include ```3. ipch```(can be deleted completely) and ```4. Romaing```(cannot be deleted completely)

#### What can be deleted regularly in 4. romaing

After further analysis of the files in```%userprofile%\AppData\Roaming\Code```, I got the following conclusions:

```
%userprofile%\AppData\Roaming\Code\CachedExtensionVSIXs   It can reach 500M in a period of time.   Can be deleted directly
%userprofile%\AppData\Roaming\Code\Cache       Soon, tens of M
%userprofile%\AppData\Roaming\Code\CachedData  Soon, tens of M
%userprofile%\AppData\Roaming\Code\CachedExtensions  When installing a new plug-in, it seems that it will not be automatically deleted by default. One or more plug-ins can reach 800M
%userprofile%\AppData\Roaming\Code\CachedExtensionVSIXs Anyway, it is also related to plug-ins and can reach several hundred M
%userprofile%\AppData\Roaming\Code\Code Cache    tens of M
%userprofile%\AppData\Roaming\Code\Crashpad      dozen M  Used to store crash information
%userprofile%\AppData\Roaming\Code\logs          tens of M  This can be deleted directly. used to store log records
%userprofile%\AppData\Roaming\Code\Service Worker 1G    
    %userprofile%\AppData\Roaming\Code\Service Worker\CacheStorage   1G  Mainly located here
    %userprofile%\AppData\Roaming\Code\Service Worker\ScriptCache    10M
%userprofile%\AppData\Roaming\Code\User          600M
    %userprofile%\AppData\Roaming\Code\User\workspaceStorage  500M  Each time you open a working directory, a folder will be generated under this directory
    %userprofile%\AppData\Roaming\Code\User\History           100M
            A copy will be generated every time Ctrl+S (only successful resave with modification).
            This is not to store changes only according to the idea of GIT, but to copy the entire file.
            A source code of more than 100 K is saved for ten times, which is 1m. For users who are used to Ctrl+S, it will occupy a large space.
            However, the deletion will affect the restoration of the historical version.
            Among them, the file name adopts the code confusion technology, and each file will generate a folder. The real file name and the corresponding file saving time of each file are all in the entries.json under each folder
    %userprofile%\AppData\Roaming\Code\User\snippets    This cannot be deleted, and you must remember to back it up (if it is not automatically restored) when reinstalling. This is a user-defined code fragment
```

### Directories that can be deleted regularly

1. ```%userprofile%\AppData\Local\Microsoft\vscode-cpptools\ipch```
2. ```%userprofile%\AppData\Roaming\Code\CachedExtensionVSIXs```
3. ```%userprofile%\AppData\Roaming\Code\Cache```
4. ```%userprofile%\AppData\Roaming\Code\CachedData```
5. ```%userprofile%\AppData\Roaming\Code\CachedExtensions```
6. ```%userprofile%\AppData\Roaming\Code\CachedExtensionVSIXs```
7. ```%userprofile%\AppData\Roaming\Code\Code Cache```
8. ```%userprofile%\AppData\Roaming\Code\Crashpad```
9. ```%userprofile%\AppData\Roaming\Code\logs```
10. ```%userprofile%\AppData\Roaming\Code\Service Worker\CacheStorage```
11. ```%userprofile%\AppData\Roaming\Code\Service Worker\ScriptCache```
12. ```%userprofile%\AppData\Roaming\Code\User\workspaceStorage```
13. ```%userprofile%\AppData\Roaming\Code\User\History```


It is impossible to manually delete so many folders one by one, so I wrote a script:

```bash
@REM example:
@REM del "%userprofile%/AppData/Local/Microsoft/vscode-cpptools/ipch/" /s /q /f
@REM rd "%userprofile%/AppData/Local/Microsoft/vscode-cpptools/ipch/" /s /q
@REM md "%userprofile%/AppData/Local/Microsoft/vscode-cpptools/ipch/"

@echo off

call:EmptyOneDir "%userprofile%\AppData\Local\Microsoft\vscode-cpptools\ipch"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\CachedExtensionVSIXs"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\Cache"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\CachedData"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\CachedExtensions"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\CachedExtensionVSIXs"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\Code Cache"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\Crashpad"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\logs"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\Service Worker\CacheStorage"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\Service Worker\ScriptCache"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\User\workspaceStorage"
call:EmptyOneDir "%userprofile%\AppData\Roaming\Code\User\History"

goto end

:EmptyOneDir  rem same as Let empty [path] /q
    echo empty %1
    echo del %1 /s /q /f
    del %1 /s /q /f
    echo rd %1 /s /q
    rd %1 /s /q
    echo md %1
    md %1
:end
```

**Just save this script as CleanVsCode.bat and double-click it to run it once regularly, which can release a lot of space regularly**

Of course, the free space directly depends on the cache size generated by your VsCode, and indirectly depends on the number of times your VsCode is used.

It will be better to close VsCode before running the script.

### ⚠️Warning

After running the script, running vscode again basically does not show any difference, except that the files opened under the current working path need to be manually opened again.

After all, it is a script that can delete many things, so please use it with caution.

As the original author of this small project, I only provide you with a convenient method, but the author is not responsible for the possible consequences.

But you can rest assured that I am also running this script regularly.

When you are ready to join the Windows plan, you can automatically release space on a regular basis.

<!-- > 原创不易，转载请附上[原文链接](https://letmefly.blog.csdn.net/article/details/126082324)哦~ -->
> My CSDN：[https://letmefly.blog.csdn.net/article/details/126082324](https://letmefly.blog.csdn.net/article/details/126082324)
