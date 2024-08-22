PHONY: init build test

.init:
	rm -rf .venv
	python -m venv .venv
	./.venv/bin/pip install -e ./py[test,bench]
	./.venv/bin/pre-commit install
	touch .init

.clean:
	rm -rf .init

init: .clean .init

build-develop: .init
	. ./.venv/bin/activate && maturin develop -m py/Cargo.toml
	. ./.venv/bin/activate && maturin develop -m json/Cargo.toml

test: build-develop
	cargo test
	./.venv/bin/python -m pytest -s

lint: build-develop
	./.venv/bin/pre-commit run --all-files
