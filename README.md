# CDFrames - WoW 1.12 addOn 

This addOn adds frames with icons and countdowns for enemies' as well as your own cooldowns.

![Alt text](http://i.imgur.com/TzA8EUk.png)

![Alt text](http://i.imgur.com/BSjkHZT.png)

### Commands

**/cdframes on** (activates frames, default on)<br/>
**/cdframes off** (deactivates frames)<br/>
**/cdframes lock** (locks frames, default off)<br/>
**/cdframes unlock** (unlocks frames)<br/>
**/cdframes size x** (maximum number of timers per frame, **x** between 1 and 100, default 16)<br/>
**/cdframes line x** (maximum number of timers per line, **x** between 1 and 100, default 8)<br/>
**/cdframes scale x** (**x** between 0.5 and 2, default 1)<br/>
**/cdframes clickthrough** (toggles click-through behavior, default off)<br/>
**/cdframes blink x** (starts blinking at **x** seconds, default 7, 0 to deactivate)<br/>
**/cdframes animation** (cooldown shadow animation, default off)<br/>
**/cdframes count x** (counter style, **x** between 0 and 2, default 1, 0 means no counter)<br/>
**/cdframes ignore add list** (**list** is a comma separated list of skill names to ignore, no spaces except within the name, case insensitive. example: **mortal strike,blink,shadow word: pain**)<br/>
**/cdframes ignore remove list**<br/>
**/cdframes ignore** (shows the current ignore lists)<br/>
**/cdframes reset** (restores the defaults for all settings)<br/>

If you use **player**, **target**, **targettarget** or a comma separated list of these as the first parameter the command will only be applied for the specified frames.

When unlocked you can drag the frame with the left button or rotate it by **\<Left Click>**. **\<Right Click>** has the same effect as **/cdframes frame lock**.
