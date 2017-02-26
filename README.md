# cdframes - WoW 1.12 addOn

This addOn adds frames with icons and countdowns for your as well as other players' cooldowns.

![Alt text](http://i.imgur.com/Yrd8vPf.png)

![Alt text](http://i.imgur.com/xNKjlus.png)

### Commands

**/cdframes used** (shows player cooldowns only for the spells used, ignoring shared cooldowns, default on)<br/>
**/cdframes frame name code** (Adds a new frame with name **name**. **code** is a lua expression which must evaluate to the name of the unit who's cooldowns the frame should show. Without **code** the frame is removed and without **name** the existing frames are listed)<br/>

#### For the following commands the first parameter must be a comma separated list of frame names or **```*```** for all frames

**/cdframes lock** (locks frames, default off)<br/>
**/cdframes unlock** (unlocks frames)<br/>
**/cdframes size x** (maximum number of timers per frame, **x** between 1 and 100, default 15)<br/>
**/cdframes line x** (maximum number of timers per line, **x** between 1 and 100, default 8)<br/>
**/cdframes scale x** (**x** between 0.5 and 2, default 1)<br/>
**/cdframes spacing x** (**x** between 0 and 1, default 0, represents fraction of icon size)<br/>
**/cdframes skin** (changes the style. available skins: blizzard, zoomed, elvui, darion)<br/>
**/cdframes blink x** (starts blinking at **x** seconds, default 0)<br/>
**/cdframes animation** (cooldown shadow animation, default off)<br/>
**/cdframes count** (toggles the countdown, default on)<br/>
**/cdframes ignore add list** (**list** is a comma separated list of skill names to ignore, no spaces except within the name, case insensitive. example: **mortal strike,blink,shadow word: pain**)<br/>
**/cdframes ignore remove list**<br/>
**/cdframes ignore** (shows the current ignore lists)<br/>
**/cdframes clickthrough** (toggles click-through behavior, default off)<br/>
**/cdframes reset** (restores the defaults for all settings)<br/>

When unlocked you can drag the frame with the left button or rotate it by **\<Left Click>**. **\<Right Click>** has the same effect as **/cdframes frame lock**.
