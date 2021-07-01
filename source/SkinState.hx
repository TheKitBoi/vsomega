package;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import haxe.Exception;
using StringTools;
import flixel.util.FlxTimer;
import Options;


class SkinState extends MusicBeatState {
  public static var selectedSkin = 'bf';
  public static var skins = ["bf","naikaze","mikeeey","tgr","erderi","babyvase","bfside","bf-neb"];
  public static var skinNames = ["Default","Naikaze","Mikeeey","TheGhostReaper","Erderi the Fox","Fun-sized Vase","Fun-sized Brightside","Nebby"];
  public var unlockedSkins:Array<String> = ["bf","mikeeey","tgr"];
  public var unlockedNames:Array<String> = ["Default","Mikeeey","TheGhostReaper"];
  public var characters:Array<Character> = [];
  public var selectedIdx:Int = 0;

  var selectedTimer:Float = 0;
  var lastAnimTimer:Float = 0;

  override function create(){
    var bg = new FlxSprite().loadGraphic(Paths.image("equipBG"));
    bg.antialiasing=true;
    bg.updateHitbox();
    bg.screenCenter(XY);
    add(bg);
    for(skin in unlockedSkins){
      var char = new Character(0,300,skin,true);
      char.screenCenter(X);
      char.visible=false;
      add(char);
      characters.push(char);
    }
    Conductor.changeBPM(102);
    Conductor.songPosition = FlxG.sound.music.time;
    super.create();
  }

  override function beatHit(){
    for(char in characters){
      if(!char.animation.name.startsWith("sing")){
        char.dance();
      }
    }
  }

  var animIdx=0;
  var anims = ["singUP","singRIGHT","singDOWN","singLEFT","hey"];

  override function update(elapsed:Float){
    FlxG.camera.zoom = .7;
    selectedTimer+=elapsed;
    if(selectedTimer>=5){
      lastAnimTimer+=elapsed;
      if(lastAnimTimer>=.5){
        lastAnimTimer=0;
        if(animIdx>=anims.length){
          animIdx=0;
          characters[selectedIdx].playAnim("idle",true);
          selectedTimer=0;
        }else{
          characters[selectedIdx].playAnim(anims[animIdx],true);
          animIdx++;
        }
      }
    }

    characters[selectedIdx].visible=true;

    Conductor.songPosition = FlxG.sound.music.time;
    if (controls.BACK)
    {
      FlxG.sound.play(Paths.sound('cancelMenu'));
      FlxG.switchState(new MainMenuState());
    }

    super.update(elapsed);
  }
}
