all:
	git submodule update --init --remote --recursive
	$(MAKE) -C ./tree-sitter-horn
	shards install
	shards build
