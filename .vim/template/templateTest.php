<?php

//set_include_path(implode(PATH_SEPARATOR,
//array(
//	get_include_path(),
//	dirname(__FILE__).'/lib',
//)));
require_once 'PHPUnit/Framework.php';
require_once '<%= substitute(expand('%:t:r'), 'Test$', '', 'e') %>.php';

class <+FILENAME_NOEXT+> extends PHPUnit_Framework_TestCase
{
	public function setUpBeforeClass() {}
	public function setUp() {
		$this->obj = new <%= substitute(expand('%:t:r'), 'Test$', '', 'e') %>();
	}

	public function test() {
		$this->assertTrue(true);
		$this->assertEquals(true, $this->obj);
		$this->assertType('integer', $this->obj);
		$this->assertLessThanOrEqual(30, 20);
	}

	public function tearDown() {}
	public function tearDownAfterClass() {}
}
