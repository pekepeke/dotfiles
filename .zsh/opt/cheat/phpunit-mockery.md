Mokery
======

## sample

```
use Mockery as m;

class FugaTest extends PHPUnit_Framework_TestCase
{
	public function tearDown() {
		m::close();
	}

	public function test() {
		$service = m::mock("FugaService");
		$service->shouldReceive("read")->times(3)->andReturn(5);
		$service
			->shouldReceive("next")
			->withAnyArgs() // withNoArgs, with(arg1)
			->times(3)      // once, twice, never
			->andSet("prop", 15)
			->andThrow(new RuntimeException("sample"));
			// andReturnNull, andReturnValues, andReturnUsing(closure)

		// alias (まだロードされていないクラスに対して有効)
    $mock = m::mock('alias:MyNamespace\MyClass');
		$mock = m::mock('overload:MyNamespace\MyClass');

		// partial mock
    $mock = m::mock('MyNamespace\MyClass[foo,bar]');
		$mock = m::mock('MyClass')->makePartial();
		$mock = m::mock('MyClass')->shouldDeferMissing();
		m::mock('MyClass')->makePartial()
				->shouldDeferMissing()
				->shouldAllowMockingProtectedMethods(); // protected も mock 化できるように

		// proxy partial mock
		$mock = m::mock(new MyClass);

	}
}

```

