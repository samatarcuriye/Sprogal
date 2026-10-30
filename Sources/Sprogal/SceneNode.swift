




open class SceneNode: GroupNode {
    
    
    
    public var size: Size2D = Size2D(width: 3840, height: 2160)
    
    
    
    public var fps: Int = 60
    
    
    
    private var isConstructed = false
    
    
    
    public var backgroundColor: Color = .black
    
    
    
    public var frameCount: Integer {
        self.build()
        return max(0, self.lastFrame ?? 0) + 1
    }
    
    open func construct() {}
    
    
    
    public final func build() {
        guard !self.isConstructed else { return }
        self.isConstructed = true
        self.construct()
    }
    
    
    
    
    
    
    public final func renderFrame(_ frame: Integer, in canvas: Canvas) {
        self.build()
        canvas.save()
        canvas.translate(by: Vector2D(dx: self.size.width / 2, dy: self.size.height / 2))
        self.render(frame: frame, in: canvas)
        canvas.restore()
    }
    
    
    
    
    
}
