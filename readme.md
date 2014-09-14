# urequire-cli v0.7.0

> The [uRequire](http://urequire.org) Command Line Interface.

Install this globally and you'll have access to the `urequire` command anywhere on your system.

```shell
npm install -g urequire-cli
```

**Note:** The job of the `urequire` command is to load and run the version of uRequire you have installed locally to your project, irrespective of its version.  Starting with uRequire v0.7, you should never install uRequire itself globally.  For more information about why, [please read this](http://blog.nodejs.org/2011/03/23/npm-1-0-global-vs-local-installation).

See the [Using uRequire](http://urequire.org/using-urequire) guide for more information.

## Installing urequire-cli locally
If you prefer the idiomatic Node.js method to get started with a project (`npm install && npm test`) then install urequire-cli locally with `npm install urequire-cli --save-dev`. Then add a script to your `package.json` to run the associated urequire command: `"scripts": { "test": "urequire test" } `. Now `npm test` will use the locally installed `./node_modules/.bin/urequire` executable to run your uRequire commands.

To read more about npm scripts, please visit the npm docs: [https://npmjs.org/doc/misc/npm-scripts.html](https://npmjs.org/doc/misc/npm-scripts.html).

# License

The MIT License

Copyright (c) 2013-2014 Agelos Pikoulas (agelos.pikoulas@gmail.com)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
