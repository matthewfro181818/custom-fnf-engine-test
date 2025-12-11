package objects.notes;

class SustainNote extends Note {
    public var parent:Note;

    public function new(parent:Note, index:Int) {
        super(parent.strumTime + index * 50, parent.lane, 0, parent.type, parent.mustPress);
        this.parent = parent;
        this.isSustainNote = true;
    }
}
