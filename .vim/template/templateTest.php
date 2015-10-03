<?php

// require '<%= substitute(expand('%:t:h'), 'Test', '', 'ie') %>';

class <%= substitute(substitute(expand('%:p:t:r'), '\(^.\)', '\u\1', ''), '_\(.\)', '\u\1', 'g') %> extends PHPUnit_Framework_TestCase
{
    /**
     * @var <%= substitute(expand('%:t:r'), 'Test', '', 'ie') %>
     */
    protected $object;

    /**
     * This method is called before a test is executed.
     */
    public function setUp()
    {
        parent::setUp();
        $this->object = new <%= substitute(expand('%:t:r'), 'Test', '', 'ie') %>;
    }

    /**
     * This method is called after a test is executed.
     */
    public function tearDown()
    {
        parent::tearDown();
    }

    /**
     *
     * @covers <%= substitute(expand('%:t:r'), 'Test', '', 'ie') %>::XXX
     * @todo   Implement testXXX().
     */
    public function testXXX()
    {
        $this->assertEquals(
          0,
          $this->object->add(0, 0)
        );
        $this->markTestIncomplete(
            'This test has not been implemented yet.'
        );
    }
}

