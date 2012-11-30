TESTS:=$(wildcard *Test.php)
TEST_TARGETS=$(patsubst %,run_%,$(TESTS))
.PHONY: test autotest

test: $(TEST_TARGETS)

run_%: check_php_unit
	@echo Running test $(*)
	phpunit $(*)

check_php_unit:
	@echo Checking for php unit

autotest:
	echo $(TESTS) | xargs ./singlestakeout.py phpunit

