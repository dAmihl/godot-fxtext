# godot-fxtext
Godot plugin for creating dynamic text effects.
If Godot 3.2 is already released, I want to refer to this feature:
[Pull request of Text Effects on RichTextLabels](https://github.com/godotengine/godot/pull/23658)

## Text engine which makes it possible to add special effects to certain words!
As shown here: 
[Reddit link](https://www.reddit.com/r/godot/comments/e6zmdz/learning_gdscript_decided_to_try_to_incorporate)

## How to use?
The script gdfxtext_base.gd is working by itself. Just add it to a Node2D and set your desired properties.

In order to use effects you have to create a new script extending the gdfxtext_base.gd script.
The relevant functions to override are:
* init_gdfxtexts: if you want to add any custom initialization
* modify_word(String): this function is called for every word. You can modify the word before printing it in any way you want.
In the stutter example, this is the method where the words are dynamically modified
* check_apply_effect(String, String): this function evaluates if the effect is to apply to this word. First parameter is the original, unmodified word. The second is the modified word.

The effect itself comes from the Label the script should apply on words where check_apply_effect() evaluates to true.
In order to create a new effect a new script extending Label is required. Create your effect in the \_process() function

## Performance
The "effects" are created by instantiating a new label for each character with the effect.
Other words are currently printed one label per word. This is in no way optimized :)
Please take this into consideration.
