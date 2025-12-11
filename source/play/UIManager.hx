package play;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import util.Paths;

class UIManager {
    public var ps:PlayState;

    // HUD elements
    public var healthBar:FlxSprite;
    public var healthBarBG:FlxSprite;
    public var iconP1:FlxSprite;
    public var iconP2:FlxSprite;

    public var scoreText:FlxText;
    public var botplayText:FlxText;

    // Health values
    public var health:Float = 1.0; // 0 to 2

    // Score and combos
    public var score:Int = 0;
    public var combo:Int = 0;

    // danger flashing
    private var dangerFlash:Bool = false;
    private var dangerTimer:Float = 0;

    public function new(ps:PlayState) {
        this.ps = ps;
        createUI();
    }

    // =====================================================================
    // UI CREATION
    // =====================================================================

    private function createUI() {
        // HEALTHBAR BG
        healthBarBG = new FlxSprite(0, 0).makeGraphic(400, 30, FlxColor.BLACK);
        healthBarBG.scrollFactor.set();
        healthBarBG.cameras = [ps.cameraManager.camHUD];
        ps.add(healthBarBG);

        // HEALTHBAR FILL
        healthBar = new FlxSprite(0, 0).makeGraphic(398, 28, FlxColor.RED);
        healthBar.scrollFactor.set();
        healthBar.cameras = [ps.cameraManager.camHUD];
        ps.add(healthBar);

        // PLAYER & OPPONENT ICONS
        iconP1 = new FlxSprite().loadGraphic(Paths.icon("bf"));
        iconP1.antialiasing = true;
        iconP1.cameras = [ps.cameraManager.camHUD];
        ps.add(iconP1);

        iconP2 = new FlxSprite().loadGraphic(Paths.icon("dad"));
        iconP2.antialiasing = true;
        iconP2.cameras = [ps.cameraManager.camHUD];
        ps.add(iconP2);

        // SCORE TEXT
        scoreText = new FlxText(0, 60, FlxG.width, "Score: 0", 20);
        scoreText.alignment = "center";
        scoreText.scrollFactor.set();
        scoreText.cameras = [ps.cameraManager.camHUD];
        ps.add(scoreText);

        // BOTPLAY
        botplayText = new FlxText(0, FlxG.height - 120, FlxG.width, "BOTPLAY", 32);
        botplayText.alignment = "center";
        botplayText.color = FlxColor.CYAN;
        botplayText.alpha = 0;
        botplayText.scrollFactor.set();
        botplayText.cameras = [ps.cameraManager.camHUD];
        ps.add(botplayText);

        repositionHUD();
    }

    // =====================================================================
    // REPOSITION (Downscroll / Upscroll / Screen size)
    // =====================================================================

    public function repositionHUD() {
        healthBarBG.screenCenter(X);
        healthBarBG.y = ps.downscroll ? 50 : FlxG.height - 70;

        healthBar.x = healthBarBG.x + 1;
        healthBar.y = healthBarBG.y + 1;

        iconP1.x = healthBarBG.x - 60;
        iconP1.y = healthBarBG.y - 10;

        iconP2.x = healthBarBG.x + healthBarBG.width + 20;
        iconP2.y = healthBarBG.y - 10;
    }

    // =====================================================================
    // UPDATE (called from PlayState)
    // =====================================================================

    public function update(elapsed:Float) {
        updateHealthBar();

        scoreText.text = "Score: " + score;

        if (dangerFlash) {
            dangerTimer += elapsed;
            var pulse = Math.sin(dangerTimer * 20);
            healthBar.color = FlxColor.interpolate(FlxColor.RED, FlxColor.WHITE, (pulse + 1) / 2);
        }

        // toggle botplay text
        botplayText.alpha = ps.autoPlayer.enabled ? 1 : 0;
    }

    // =====================================================================
    // HEALTH SYSTEM
    // =====================================================================

    private function updateHealthBar() {
        var fill = FlxMath.bound(health, 0, 2);
        healthBar.scale.x = fill;

        // center left side if shrinking
        healthBar.x = healthBarBG.x + (healthBarBG.width - healthBar.width * fill) / 2;
    }

    public function addHealth(amount:Float) {
        health += amount;
        if (health > 2) health = 2;
    }

    public function applyMissPenalty() {
        health -= 0.15;
        if (health < 0) health = 0;

        dangerFlash = health <= 0.4;
    }

    // =====================================================================
    // SCORE & COMBO SYSTEM
    // =====================================================================

    public function addScore(rating:String) {
        combo++;

        switch (rating) {
            case "sick": score += 350;
            case "good": score += 200;
            case "bad":  score += 50;
        }

        if (combo % 10 == 0)
            flashCombo();
    }

    private function flashCombo() {
        FlxTween.tween(scoreText, { alpha: 0.1 }, 0.05, {
            onComplete: (_) -> FlxTween.tween(scoreText, { alpha: 1 }, 0.1)
        });
    }

    // =====================================================================
    // ICON MANIPULATION
    // =====================================================================

    public function setIconById(player:Int, name:String) {
        if (player == 1)
            iconP1.loadGraphic(Paths.icon(name));
        else
            iconP2.loadGraphic(Paths.icon(name));
    }

    public function setIconState(player:Int, state:String) {
        var icon = (player == 1 ? iconP1 : iconP2);

        switch (state) {
            case "normal": icon.scale.set(1, 1);
            case "winning": icon.scale.set(1.2, 1.2);
            case "danger": icon.scale.set(0.8, 0.8);
        }
    }

    // =====================================================================
    // SCRIPT API HELPERS
    // =====================================================================

    public function tweenHUDAlpha(value:Float, time:Float) {
        FlxTween.tween(camHUD, { alpha: value }, time);
    }

    public function pulseHUD() {
        FlxTween.tween(camHUD, { zoom: camHUD.zoom + 0.03 }, 0.1, {
            onComplete: (_) -> camHUD.zoom = ps.cameraManager.camHUD.zoom
        });
    }
}
