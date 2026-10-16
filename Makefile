root_dir=.
dst_dir=./dist
build_dir=./build
build_src=./build/src
package_name=$(shell node -p -e "require('./package.json').name")
package_root=$(shell node -p -e "require('./package.json').pluginName")
script_name=$(shell node -p -e "require('./package.json').pluginName.toLowerCase()").umd.js
plugin_dir=$(build_src)/$(package_root)

# Backend folders copied into the package when they exist
backend_dirs=App Attributes Controllers Hooks Listeners Scopes Models Services migrations Migration routes
# Single files copied into the package when they exist (all files referenced in plugin.xml)
package_files=plugin.xml CHANGELOG.md composer.json role-presets.json src/exported.css

# all steps for an appstore release
release: npm_init npm_build package

prebuild_release: clean package

npm_init:
	npm install

npm_build:
	npx vite build

validate:
	xmllint --noout --schema plugin.xsd plugin.xml

# remove build dir
clean:
	rm -rf $(build_dir)

package: clean
	@[ -f $(dst_dir)/$(script_name) ] || (echo "Missing $(dst_dir)/$(script_name), run 'make npm_build' first" && exit 1)
	mkdir -p $(plugin_dir)/js
	@for dir in $(backend_dirs); do \
		if [ -d $$dir ]; then cp -R $$dir $(plugin_dir)/; fi; \
	done
	@for file in $(package_files); do \
		if [ -f $$file ]; then mkdir -p $(plugin_dir)/$$(dirname $$file) && cp $$file $(plugin_dir)/$$file; fi; \
	done
	if [ -d vendor ]; then cp -R vendor $(plugin_dir)/; fi
	cp $(dst_dir)/$(script_name) $(plugin_dir)/js/script.js
	tar -czf $(build_dir)/$(package_name).tar.gz \
	   --directory="$(build_src)" $(package_root)
	(cd $(build_src) && zip ../$(package_name).zip -r .)
	rm -rf $(build_src)

.PHONY: release prebuild_release npm_init npm_build validate clean package
