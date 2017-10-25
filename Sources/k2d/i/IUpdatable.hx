//TODO: Proper package name
package k2d.i;

interface IUpdatable {
	public function onPreUpdate(delta: Float): Void;
	public function onUpdate(delta: Float): Void;
	public function onPostUpdate(delta: Float): Void;
}