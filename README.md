# cooldowns - WoW 1.12 addOn 

This addOn adds frames with icons and countdowns for enemies' as well as your own cooldowns.

![Alt text](http://i.imgur.com/Yrd8vPf.png)

![Alt text](http://i.imgur.com/xNKjlus.png)

### Commands

**/cooldowns used** (shows player cooldowns only for the spells used, ignoring shared cooldowns, default on)<br/>
**/cooldowns frame name code** (Adds a new frame with name **name**. **code** is a lua expression which must evaluate to the name of the unit who's cooldowns the frame should show. Without **code** the frame is removed and without **name** the existing frames are listed)<br/>

## For the following commands the first parameter must be a comma separated list of frame names or **\*** for all frames

**/cooldowns on** (activates frames, default on)<br/>
**/cooldowns off** (deactivates frames)<br/>
**/cooldowns lock** (locks frames, default off)<br/>
**/cooldowns unlock** (unlocks frames)<br/>
**/cooldowns size x** (maximum number of timers per frame, **x** between 1 and 100, default 15)<br/>
**/cooldowns line x** (maximum number of timers per line, **x** between 1 and 100, default 8)<br/>
**/cooldowns scale x** (**x** between 0.5 and 2, default 1)<br/>
**/cooldowns spacing x** (**x** between 0 and 1, default 0, represents fraction of icon size)<br/>
**/cooldowns skin** (changes the style. available skins: blizzard, zoomed, elvui, darion)<br/>
**/cooldowns blink x** (starts blinking at **x** seconds, default 0)<br/>
**/cooldowns animation** (cooldown shadow animation, default off)<br/>
**/cooldowns count** (toggles the countdown, default on)<br/>
**/cooldowns ignore add list** (**list** is a comma separated list of skill names to ignore, no spaces except within the name, case insensitive. example: **mortal strike,blink,shadow word: pain**)<br/>
**/cooldowns ignore remove list**<br/>
**/cooldowns ignore** (shows the current ignore lists)<br/>
**/cooldowns clickthrough** (toggles click-through behavior, default off)<br/>
**/cooldowns reset** (restores the defaults for all settings)<br/>

When unlocked you can drag the frame with the left button or rotate it by **\<Left Click>**. **\<Right Click>** has the same effect as **/cooldowns frame lock**.
