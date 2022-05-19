.PHONY: render
render: clean
	poetry run cruft create file://. --no-input --extra-context='{"slug": "test-package", "name": "test-package"}'

.PHONY: test
test: render
	make -C test-package lint

.PHONY: clean
clean:
	rm -rf ./test-package
