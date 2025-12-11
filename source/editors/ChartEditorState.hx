package editors;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.text.FlxText;

import editors.ui.EditorUI;
import backend.ChartLoader;
import backend.UnifiedChart;

class ChartEditorState extends FlxState {
    var chart:UnifiedChart;
    var timeline:EditorTimeline;
    var bpm:Float = 150;

    override public function create() {
        super.create();

        add(EditorUI.label(20,20,"CHART EDITOR"));

        // Load chart or create new
        chart = ChartLoader.loadOrNew("mods/exampleMod/data/testSong/chart.json");

        timeline = new EditorTimeline(chart);
        add(timeline);

        // Add controls
        add(EditorUI.button(20, 70, "PLAY", function() timeline.play()));
        add(EditorUI.button(120, 70, "STOP", function() timeline.stop()));
        add(EditorUI.button(20, 120, "SAVE", saveChart));
        add(EditorUI.button(120, 120, "LOAD", loadChart));
    }

    function saveChart() {
        ChartLoader.save(chart, "mods/exampleMod/data/testSong/chart.json");
        FlxG.log.notice("Saved chart");
    }

    function loadChart() {
        chart = ChartLoader.load("mods/exampleMod/data/testSong/chart.json");
        timeline.setChart(chart);
    }
}
