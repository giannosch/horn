all:
	git submodule update --init --remote --recursive
	$(MAKE) -C ./tree-sitter-horn libtree-sitter-horn.a
	shards install
	shards build
