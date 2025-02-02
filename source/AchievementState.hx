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
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
typedef AchievementData ={
  var name:String;
  var desc:String;
  var rarity:String;
  var condition:String;
}

class AchievementState extends MusicBeatState
{
  public static var songs = [
    "Prelude",
    "New-Retro", // Kapi
    "57.5hz", // Demi
    "Free-Soul", // Merch
    "No-Arm-Shogun", // Flexy
    "Fragmented-Surreality", // Noke
    "Oxidation", // Anders
    'Mercenary',
    'Odd-Job',
    'Guardian',
    'Last-Stand',
    'Curse-Eternal',
    '2v200',
    'After-the-Ashes',
    'Father-Time',
    'Dishonor',
    "Salem"
  ];
  public static var omegaSongs = [
    "Mercenary",
    "Odd-Job",
    "Guardian",
    "Last-Stand",
    "Curse-Eternal",
    "2v200",
    "After-the-Ashes",
    "Father-Time",
  ];
  public static var glitchSongs = [
    "Prelude",
    "New-Retro", // Kapi
    "57.5hz", // Demi
    "Free-Soul", // Merch
    "No-Arm-Shogun", // Flexy
    "Fragmented-Surreality", // Noke
    "Oxidation", // Anders
    'Mercenary',
    'Odd-Job',
    'Guardian',
    'Last-Stand',
    'Curse-Eternal',
    '2v200',
    'After-the-Ashes',
    "Salem"
  ];

  var selectionRing:FlxSprite;
  var medals:FlxTypedGroup<FlxSprite>;
  var selectedX:Int = 0;
  var selectedY:Int = 0;
  var bigMedal:FlxSprite;
  var badgeDesc:FlxText;
  var badgeName:FlxText;
  public static var notifUp:Bool=false;
  public static var toUnlock:Array<String> = [];
  public static var unlockedMedals = [];
  public static var rarityPriorities = ["common","rare","epic","legendary","hidden","troll"];
  public static var achievementData:Array<AchievementData> = [
    {name: "Prepared", desc: "Let's see where this goes!", rarity: "common", condition: "beatPrelude"},
    {name: "Swordplay", desc: "The swordsman is protecting her for a reason, better find out why.", rarity: "common", condition: "beatMercenary"},
    {name: "Payday", desc: "He’s got an ironclad will. Is this more than just a kidnapping?", rarity: "common", condition: "beatOdd-Job"},
    {name: "Split Decision", desc: "The choice is yours.", rarity: "common", condition: "beatGuardian"},

    {name: "Bittersweet", desc: "Say your final goodbyes and leave this time as a hero.", rarity: "rare", condition: "beatAfter-the-Ashes"},
    {name: "Cruel", desc: "Finish the job you started.", rarity: "rare", condition: "beatCurse-Eternal"},
    {name: "Apocalyptic", desc: "Face off against the defender of a ravaged world.", rarity: "rare", condition: "unlockNew-Retro"},
    {name: "Reconnected", desc: "Rescue the spelunker with a gem affinity.", rarity: "rare", condition: "unlockFragmented-Surreality"},
    {name: "Smoked Out", desc: "Jam out with the laid-back salesman with a hidden ability.", rarity: "rare", condition: "unlockFree-Soul"},
    {name: "Feudal", desc: "Spar with the unlikely swordsman to rival even the greatest.", rarity: "rare", condition: "unlockNo-Arm-Shogun"},
    {name: "Overclocked", desc: "Attempt to pull the plug on the supercharged dragon.", rarity: "rare", condition: "unlock57.5hz"},
    {name: "Liquidated", desc: "Confront the mysterious figure who has stalked you throughout your journey.", rarity: "rare", condition: "unlockOxidation"},

    {name: "Butterfly Effect", desc: "Conquer every distortion with flawless grace.", rarity: "epic", condition: "beatcameos"},
    {name: "Rampage", desc: "Go toe-to-toe with the swordsman and come out on top.", rarity: "epic", condition: "beatLast-Stand"},
    {name: "Defy the Odds", desc: "Dismantle the army that has subjugated all opposition.", rarity: "epic", condition: "beat2v200"},
    {name: "Down with the Patriarch", desc: "Find the root of the problem", rarity: "epic", condition: "beatFather-Time"},
    {name: "Dethroned", desc: "Deny responsibility and face the consequences", rarity: "epic", condition: "beatDishonor"},
    {name: "Full Playthrough", desc: "Your story ends here, but there’s still more mysteries to uncover.", rarity: "epic", condition: "finishomega"},

    {name: "Temporal Overlord", desc: "Your story truly ends here.", rarity: "legendary", condition: "custom"},
    {name: "Temporal Expert", desc: "Strike down all of your opponents without even a single mistake.", rarity: "legendary", condition: "fcall"},
    {name: "Gobbledygook", desc: "Even in the face of a broken, lethal challenge, come out on top.", rarity: "legendary", condition: "glitchfcall"},
    {name: "Dance of Death", desc: "Defeat the swordsman without so much as a scratch on you.", rarity: "legendary", condition: "fcLast-Stand"},
    {name: "Two-Man Army", desc: "Crush the royal fleet in perfect unison.", rarity: "legendary", condition: "fc2v200"},
    {name: "All in the Family", desc: "Sing this final song with immaculate skill and prove your worth once and for all.", rarity: "legendary", condition: "fcFather-Time"},
    {name: "Kakorrhaphiophobia", desc: "Don’t make a single misstep or it’ll cost you.", rarity: "legendary", condition: "flashyfcall"},

    {name: "Circus of Fools", desc: "You really ARE a fool.", rarity: "hidden", condition: "beathivemind"},
    {name: "Break the Cycle", desc: "Prove that not even a shattered reality can hold you back.", rarity: "hidden", condition: "fchivemind"},
    {name: "Waste of Time", desc: "What did you expect? You have a microphone, he has a sword.", rarity: "hidden", condition: "custom"},
    {name: "Thats not how you do it", desc: "Uh… aren’t you supposed to be better than THAT?", rarity: "hidden", condition: "custom"},

    {name: "LOL", desc: "Nice.", rarity: "troll", condition: "custom"},
  ];

  public function changeSelection(changeX:Int,changeY:Int){
    selectedX+=changeX;
    selectedY+=changeY;
    if(selectedX<0)
			selectedX=Std.int(medals.members.length/5)-1;
		if(selectedX>=Std.int(medals.members.length/5))
			selectedX=0;

    if(selectedY<0)
			selectedY=Std.int(medals.members.length/6)-1;
		if(selectedY>=Std.int(medals.members.length/6))
			selectedY=0;
  }

  public static function unlockMedal(name){
    for(data in achievementData){
      if(data.name.toLowerCase()==name.toLowerCase()){
        FlxG.state.openSubState(new AchievementSubState(data.name,data.rarity));
      }
    }
  }

  public static function dataFromName(name:String):Null<AchievementData>{
    for(idx in 0...achievementData.length){
      var data = achievementData[idx];
      if(data.name.toLowerCase()==name.toLowerCase()){
        return data;
      }
    }
    return null;
  }

  public static function doUnlock(){
    var rarity = -1;
    var unlocked = '';
    for(shit in toUnlock){
      var data = dataFromName(shit);
      var pRarity= rarityPriorities.indexOf(data.rarity);
      if(pRarity>rarity){
        rarity=pRarity;
        unlocked=data.name;
      }
    }
    toUnlock=[];
    if(unlocked!='')
      unlockMedal(unlocked);
  }

  public static function checkUnlocks(){
      var len = unlockedMedals.length;
      var encounteredCameos:Array<String> = FlxG.save.data.cameos;
      var finishedSongs:Array<String> = FlxG.save.data.finishedSongs;
      var perfectedSongs:Array<String> = FlxG.save.data.perfectedSongs;
      var flashySongs:Array<String> = FlxG.save.data.flashySongs;
      var fcglitchSongs:Array<String> = FlxG.save.data.glitchSongs;


      for(idx in 0...achievementData.length){
        var data = achievementData[idx];
        var unlocked=false;
        if(data.condition.startsWith("unlock")){
          var song = data.condition.replace("unlock","");
          if(encounteredCameos.contains(song) || unlockedMedals.contains(song)){
            unlocked=true;
          }
        }else if(data.condition.startsWith("beat")){
          var song = data.condition.replace("beat","");
          if(song=='cameos'){
            unlocked=true;
            for(shit in StoryMenuState.cameos){
              if(!finishedSongs.contains(shit.toLowerCase())){
                unlocked=false;
                break;
              }
            }
          }else if(finishedSongs.contains(song.toLowerCase())){
            unlocked=true;
          }
        }else if(data.condition=='finishomega'){
          unlocked=true;
          for(i in omegaSongs){
            if(!finishedSongs.contains(i.toLowerCase())){
              unlocked=false;
              break;
            }
          }
        }else if(data.condition.startsWith("fc")){
          var song = data.condition.replace("fc","");
          if(song=='all'){
            unlocked=true;
            for(shit in songs){
              if(!FlxG.save.data.perfectedSongs.contains(shit.toLowerCase())){
                unlocked=false;
                break;
              }
            }
          }else{
            if(perfectedSongs.contains(song.toLowerCase())){
              unlocked=true;
            }
          }
        }

        if(data.condition=='flashyfcall'){
          unlocked=true;
          for(shit in songs){
            if(!flashySongs.contains(shit.toLowerCase())){
              unlocked=false;
              break;
            }
          }
        }

        if(data.condition=='glitchfcall'){
          unlocked=true;
          for(shit in fcglitchSongs){
            if(!glitchSongs.contains(shit.toLowerCase())){
              unlocked=false;
              break;
            }
          }
        }
        if(FlxG.save.data.unlocked.contains(data.name))
          unlocked=true;

        var pRarity= rarityPriorities.indexOf(data.rarity);

        if(unlocked && !unlockedMedals.contains(data.name)){
          if(len>0 && !toUnlock.contains(data.name))
            toUnlock.push(data.name);
          unlockedMedals.push(data.name);
        }
      }

      var shit:Array<String>=[];
      for(i in achievementData){
        if(i.rarity!='hidden' && i.name!='Temporal Overlord' && i.rarity!='troll'){
          shit.push(i.name);
        }
      }
      var hundredPercent=true;
      for(n in shit){
        if(!unlockedMedals.contains(n)){
          hundredPercent=false;
        }
      }
      if(hundredPercent && !unlockedMedals.contains("Temporal Overlord")){
        FlxG.save.data.unlocked.push("Temporal Overlord");
        unlockedMedals.push("Temporal Overlord");
        toUnlock.push("Temporal Overlord");
      }


  }

  override function create(){
    var bg = new FlxSprite().loadGraphic(Paths.image("nakedbook"));
    bg.screenCenter(XY);
    add(bg);
    selectionRing = new FlxSprite().loadGraphic(Paths.image('ring'));
    selectionRing.antialiasing=true;
    selectionRing.setGraphicSize(65,65);
    selectionRing.updateHitbox();
    selectionRing.offset.x += 2.5;
    selectionRing.offset.y += 2.5;
    add(selectionRing);
    medals = new FlxTypedGroup<FlxSprite>();
    add(medals);
    checkUnlocks();
    var yOffset:Int = 0;
    for(idx in 0...achievementData.length){
      var data = achievementData[idx];
      var badge:FlxSprite;
      if(unlockedMedals.contains(data.name)){
        badge = new FlxSprite(130+(85*idx%6),216+(85*yOffset)).loadGraphic(Paths.image('achievements/${data.rarity}/${data.name}'));
      }else{
        badge = new FlxSprite(130+(85*idx%6),216+(85*yOffset)).loadGraphic(Paths.image('sex_mark'));
      }

      badge.antialiasing=true;
      badge.setGraphicSize(60,60);
      badge.updateHitbox();
      if(idx%6==5){
        yOffset++;
      }
      medals.add(badge);
    }

    bigMedal = new FlxSprite(765,105);
    bigMedal.antialiasing=true;
    add(bigMedal);

    badgeName = new FlxText(625, 400, 600, "cum", 32);
		badgeName.setFormat("VCR OSD Mono", 36, FlxColor.BLACK, CENTER, OUTLINE,FlxColor.WHITE);

    badgeDesc = new FlxText(725, 435, 400, "Boyfriend.XML", 32);
		badgeDesc.setFormat("VCR OSD Mono", 30, FlxColor.BLACK, CENTER, OUTLINE,FlxColor.WHITE);

    add(badgeDesc);
    add(badgeName);

    super.create();
  }
  var selected='';
  override function update(elapsed:Float)
  {
    selectionRing.x = medals.members[selectedX+(selectedY*6)].x;
    selectionRing.y = medals.members[selectedX+(selectedY*6)].y;

    var data = achievementData[selectedX+(selectedY*6)];
    if(selected!=data.name){
      selected=data.name;
      if(unlockedMedals.contains(data.name)){
        bigMedal.loadGraphic(Paths.image('achievements/${data.rarity}/${data.name}'));
      }else{
        bigMedal.loadGraphic(Paths.image('sex_mark'));
      }
      if(data.rarity!='hidden' || unlockedMedals.contains(data.name)){
        badgeDesc.text = data.desc;
        badgeName.text = data.name;
      }else{
        badgeDesc.text = "???";
        badgeName.text = "???";
      }


      bigMedal.x = 765;
      bigMedal.y = 105;
    }

    if (controls.BACK)
    {
      FlxG.sound.play(Paths.sound('cancelMenu'));
      FlxG.switchState(new MainMenuState());
    }

    if (controls.LEFT_P)
      changeSelection(-1,0);
    if (controls.RIGHT_P)
      changeSelection(1,0);

    if (controls.UP_P)
      changeSelection(0,-1);
    if (controls.DOWN_P)
      changeSelection(0,1);

    super.update(elapsed);
  }
}
