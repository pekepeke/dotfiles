<?php

//set_include_path(implode(PATH_SEPARATOR,
//array(
//	get_include_path(),
//	dirname(__FILE__).'/lib',
//)));

require '<%= substitute(expand('%:t:h'), 'Test', '', 'ie') %>';

class <+FILENAME_NOEXT+> extends PHPUnit_Framework_TestCase {
    /**
     * @var <%= substitute(expand('%:t:r'), 'Test', '', 'ie') %>
     */
    protected $object;

    /**
     * This method is called before a test is executed.
     */
    protected function setUp() {
        $this->object = new <%= substitute(expand('%:t:r'), 'Test', '', 'ie') %>;
    }

    /**
     * This method is called after a test is executed.
     */
    protected function tearDown() {
    }

    /**
     *
     * @covers <%= substitute(expand('%:t:r'), 'Test', '', 'ie') %>::XXX
     */
    public function testXXX() {
        $this->assertEquals(
          0,
          $this->object->add(0, 0)
        );
    }
}

if (basename(__FILE__) == basename($_SERVER['PHP_SELF'])) {
}
