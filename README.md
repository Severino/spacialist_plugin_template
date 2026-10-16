# Spacialist Plugin Template

This template is meant as a starting point for Plugin Development. It is setup to work out of the box with spacialist and has a lot of developer tooling already setup, so that you don't have to setup anything on your own and you can start developing right away.

Requires Spacialist 0.12 or newer.

## Setup for Development

To setup the plugin to be ready for development follow these steps:

1. Clone this repository into the spacialist plugin folder `app/Plugins/{PluginName}`
2. Rename the plugin: set `<name>` in `plugin.xml`, `pluginName` in `package.json`, the PHP namespaces (`App\Plugins\{PluginName}\...`) and the `id` in `src/main.js` (kebab-case of the name)
3. Install node modules `npm install`
4. Run the doctor `npm run doctor` to check the setup and link the built script into Spacialist. **Note using windows you must open the shell as administrator**
5. Run spacialist and the plugin. Most easily done by running the 'dev' task from vscode.
6. Enable plugin in spacialist.
7. Develop!

## Structure

```
plugin.xml          # Manifest - REQUIRED. Schema: plugin.xsd
plugin.xsd          # Manifest schema, validate with `npm run validate` or `make validate`
App/                # Backend classes, permissions.json and role-presets.json
Attributes/         # Custom attribute types (registered in <attributes>)
Controllers/        # Controllers for routes/api.php
migrations/         # Laravel migrations (registered in <migrations>)
routes/api.php      # Plugin routes, mounted under api/v1/{plugin-slug}
src/                # Frontend sources, src/main.js is the entry point
js/script.js        # Built frontend script - REQUIRED in the package (created by `make package`)
```

Every backend class lives in the namespace `App\Plugins\{PluginName}\{Folder}`, e.g. `App/Template.php` is `App\Plugins\Template\App\Template`.

## Manifest

All features are declared in `plugin.xml`. The root element is `<plugin>` (the old `<info>` root and `App/info.xml` location still work but are deprecated). The template declares every path explicitly, so none of the deprecated defaults (`routes/api.php` without `<routes>`, the `Migration` folder, a root `role-presets.json`) are used.

| Element | What it does |
|---|---|
| `<dependencies>` | `<core min="..."/>` and `<plugin name="..." min="..." max="..."/>` |
| `<routes src="" middleware="api"/>` | Routes file. The `api` group has no authentication, add `auth:sanctum` yourself |
| `<migrations src=""/>` | Migration folder |
| `<permissions src=""/>` | Permissions json |
| `<role-presets><file src=""/></role-presets>` | Role preset json files |
| `<css><file src=""/></css>` | Stylesheets published by Spacialist |
| `<attributes><attribute src="Attributes/X"/></attributes>` | Attribute type classes extending `App\AttributeTypes\AttributeBase` |
| `<hooks><hook on="api/v1/..." method="GET" src="Class@method"/></hooks>` | Runs after a core route responded |
| `<scopes><scope src="Scopes/X" on="App\Entity"/></scopes>` | Global Eloquent scopes on core models |
| `<accesspoints><accesspoint id="" label="" path=""/></accesspoints>` | Own top level pages |

See `plugin.xsd` for all attributes and defaults.

## Release

`make release` installs the node modules, builds the script and creates `build/{name}.zip`, which can be uploaded in Spacialist. Only the folders and files referenced by the manifest are packaged (see `backend_dirs` and `package_files` in the `Makefile`).
